SHELL := /bin/bash

FEATURES=nginx flask

DOCKER_BUILD = $(addprefix docker_build_,${FEATURES})
DOCKER_RUN = $(addprefix docker_run_,${FEATURES})
DOCKER_EXEC = $(addprefix docker_exec_,${FEATURES})
DOCKER_PRODUCTION = $(addprefix docker_production_,${FEATURES})

TAG=${whoami}

all:
	echo >&2 "Must specify target."

whoami := $(shell whoami)

.PHONY: build_all
build_all: ${DOCKER_BUILD}

.PHONY: ${DOCKER_BUILD}
${DOCKER_BUILD}: docker_build_%:
	docker build -t $(TAG)-$* -f $*/Dockerfile $*/.

.PHONY: ${DOCKER_RUN}
${DOCKER_RUN}: docker_run_%: docker_build_%
	$(eval ports := $(shell if [ "$*" == "flask" ]; then echo "-p 5001:5001"; else echo "-p 80:80 -p 443:443"; fi))
	docker run -it --rm -h docker-$(TAG)-$* ${ports} --entrypoint /bin/bash --name $(TAG)-$* -v /etc/letsencrypt:/etc/letsencrypt:ro $(TAG)-$*

.PHONY: ${DOCKER_PRODUCTION}
${DOCKER_PRODUCTION}: docker_production_%:
	$(eval ports := $(shell if [ "$*" == "flask" ]; then echo "-p 5001:5001"; else echo "-p 80:80 -p 443:443"; fi))
	docker run -it --rm -h docker-$(TAG)-$* ${ports} --name $(TAG)-$* -v /etc/letsencrypt:/etc/letsencrypt:ro $(TAG)-$*

.PHONY: ${DOCKER_EXEC}
${DOCKER_EXEC}: docker_exec_%:
	docker exec -it $(TAG)-$* /bin/bash
