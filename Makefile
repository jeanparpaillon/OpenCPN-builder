TAG = $(shell git rev-parse --short HEAD)
export TAG

all: builders

builders:
	docker buildx bake --file ./docker-bake.hcl --file metadata.hcl

.PHONY: all builders
