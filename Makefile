SHELL := bash


.PHONY: all
all:


.PHONY: build
build:
	docker build \
		--pull \
		-t jbl-chat \
		.


.PHONY: publish
publish: docker-login
	docker tag jbl-chat lifeofguenter/jbl-chat:1.2
	docker push lifeofguenter/jbl-chat:1.2


.PHONY: docker-login
docker-login:
ifndef JENKINS_CI
	@if ! timeout --preserve-status --singal=KILL 3 docker login &> /dev/null; then \
		docker login ;\
	fi
endif
