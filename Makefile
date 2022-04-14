NAME = kong-with-plugins
VERSION = latest
TAG = $(NAME):$(VERSION)

all: build

build:
	docker build \
		--rm --force-rm \
		-t $(TAG) \
		.
