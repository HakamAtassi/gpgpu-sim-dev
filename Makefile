
all: run-docker 

IMAGE_NAME = gpgpu-dev-env

# only build docker if the image doenst already exist
build-docker:
	@if ! docker image inspect $(IMAGE_NAME) > /dev/null 2>&1; then \
		docker build -t $(IMAGE_NAME) .; \
	fi

run-docker: build-docker
	docker run -it --rm -v /home/hakamatassi/Repos/gpgpu-sim-dev/shared:/root/Repos/shared gpgpu-dev-env bash

nuke:
	docker rm -vf $(docker ps -aq)
	docker rmi -f $(docker images -aq)


