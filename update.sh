#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */*/Dockerfile )
fi
versions=( "${versions[@]%/*/Dockerfile}" )
versions=( $(echo "${versions[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ') )

components=(keeper proxy sentinel)

stolonVersions="$(
	git ls-remote --refs https://github.com/sorintlab/stolon.git \
		| cut -d$'\t' -f2 \
		| grep -E '^refs/tags/v[0-9]+\.[0-9]+' \
		| cut -d/ -f3 \
		| sort -rV
)"

travisEnv=
for version in "${versions[@]}"; do
	IFS=- read stolonVersion pgVersion <<< "$version"

	fullVersionName="$(
		echo "$stolonVersions" \
			| grep -E "^v${stolonVersion}([.-]|$)" \
			| head -1
	)"
	if [ -z "$fullVersionName" ]; then
		echo >&2 "error: cannot determine full Stolon release for '$stolonVersion'"
	fi

	for component in "${components[@]}"; do
		[ -d "$version/$component" ] || continue

		(
			set -x
			cp -p "templates/$component/Dockerfile.template" "templates/$component/docker-entrypoint.sh" "$version/$component/"
			mv "$version/$component/Dockerfile.template" "$version/$component/Dockerfile"
			sed -i 's/%%PG_VERSION%%/'$pgVersion'/g;s/%%STOLON_VERSION%%/'$fullVersionName'/g' "$version/$component/Dockerfile"
		)

		for variant in alpine; do
			[[ -d "templates/$component/$variant" && -d "$version/$component/$variant" ]] || continue

			(
				set -x
				cp -rp "templates/$component/$variant/Dockerfile.template" "templates/$component/$variant/docker-entrypoint.sh" "$version/$component/$variant/"
				mv "$version/$component/$variant/Dockerfile.template" "$version/$component/$variant/Dockerfile"
				sed -i 's/%%PG_VERSION%%/'$pgVersion'/g;s/%%STOLON_VERSION%%/'$fullVersionName'/g' "$version/$component/$variant/Dockerfile"
			)
		done
	done
done
