VERSIONS = $(foreach df,$(wildcard */*/alpine/Dockerfile */*/Dockerfile),$(df:%/Dockerfile=%))

all: build

build: $(VERSIONS)

define stolon-version
$1:
	docker build -t hiddeco/stolon:$(shell echo $1 | sed -e 's/\//-/g') $1
endef
$(foreach version,$(VERSIONS),$(eval $(call stolon-version,$(version))))

.PHONY: all build $(VERSIONS)
