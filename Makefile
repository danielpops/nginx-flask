SHELL := /bin/bash

FEATURES=nginx flask

DOCKER_BUILD = $(addprefix docker_build_,${FEATURES})
DOCKER_RUN = $(addprefix docker_run_,${FEATURES})
DOCKER_EXEC = $(addprefix docker_exec_,${FEATURES})
DOCKER_PRODUCTION = $(addprefix docker_production_,${FEATURES})

TAG=nginxflask

all:
	echo >&2 "Must specify target."

.PHONY: build_all
build_all: ${DOCKER_BUILD}

.PHONY: ${DOCKER_BUILD}
${DOCKER_BUILD}: docker_build_%:
	docker build -t $(TAG)_$*_1 -f $*/Dockerfile $*/.

.PHONY: ${DOCKER_RUN}
${DOCKER_RUN}: docker_run_%: docker_build_%
	$(eval ports := $(shell if [ "$*" == "flask" ]; then echo "-p 5001:5001"; else echo "-p 80:80 -p 443:443"; fi))
	docker run -it --rm -h docker-$(TAG)_$*_1 ${ports} --entrypoint /bin/bash --name $(TAG)_$*_1 -v /etc/letsencrypt:/etc/letsencrypt:ro $(TAG)_$*_1

.PHONY: ${DOCKER_EXEC}
${DOCKER_EXEC}: docker_exec_%:
	docker exec -it $(TAG)_$*_1 /bin/bash

.PHONY: production
production:
	docker-compose build
	docker-compose up
