
all: run-docker 

build-docker:
	docker build -t gpgpu-dev-env .

run-docker:
	docker run -it gpgpu-dev-env bash 

nuke:
	docker rm -vf $(docker ps -aq)
	docker rmi -f $(docker images -aq)
