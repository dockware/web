.PHONY: help build
.DEFAULT_GOAL := help


help:
	@echo "PROJECT COMMANDS"
	@echo "--------------------------------------------------------------------------------------------"
	@printf "\033[33mInstallation:%-30s\033[0m %s\n"
	@grep -E '^[a-zA-Z_-]+:.*?##1 .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?##1 "}; {printf "\033[33m  - %-30s\033[0m %s\n", $$1, $$2}'
	@echo "--------------------------------------------------------------------------------------------"
	@printf "\033[36mDevelopment:%-30s\033[0m %s\n"
	@grep -E '^[a-zA-Z_-]+:.*?##2 .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?##2 "}; {printf "\033[36m  - %-30s\033[0m %s\n", $$1, $$2}'
	@echo "--------------------------------------------------------------------------------------------"
	@printf "\033[32mTests:%-30s\033[0m %s\n"
	@grep -E '^[a-zA-Z_-]+:.*?##3 .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?##3 "}; {printf "\033[32m  - %-30s\033[0m %s\n", $$1, $$2}'

# ----------------------------------------------------------------------------------------------------------------

install: ##1 Installs all dependencies
	npm install
	composer install

clear: ##1 Clears all dependencies dangling images
	rm -rf vendor/*
	rm -rf node_modules/*
	docker images -aq -f 'dangling=true' | xargs docker rmi
	docker volume ls -q -f 'dangling=true' | xargs docker volume rm

# ----------------------------------------------------------------------------------------------------------------

generate: ##2 Generates all artifacts for this image. You can use the local PHAR with: make generate phar=1
ifndef phar
	docker run -v ${PWD}:/opt/project orcabuilder/orca:latest
else
	curl -O https://orca-build.io/downloads/orca.zip
	unzip -o orca.zip
	rm -f orca.zip
	php orca.phar --directory=. --debug
endif

# ----------------------------------------------------------------------------------------------------------------

build: ##2 Builds the provided tag [image=play tag=6.1.6]
ifndef tag
	$(warning Provide the required image tag using "make build image=play tag=6.1.6")
	@exit 1;
else
	#@./node_modules/.bin/dockerfilelint ./dist/images/$(image)/$(tag)/Dockerfile
	@cd ./dist/images/$(image)/$(tag) && DOCKER_BUILDKIT=1 docker build --no-cache -t dockware/$(image):$(tag) .
endif

# ----------------------------------------------------------------------------------------------------------------

verify: ##3 Verify the configuration of the provided tag [image=play tag=6.1.6]
ifndef tag
	$(warning Provide the required image tag using "make verify image=play tag=6.1.6")
	@exit 1;
else
	@php ./build/Scripts/verify-config.php $(image) $(tag)
endif

test: ##3 Runs all SVRUnit Test Suites for the provided image and tag
	php ./vendor/bin/svrunit test --configuration=./tests/svrunit/suites/$(image)/$(tag).xml --list-suites
	php ./vendor/bin/svrunit test --configuration=./tests/svrunit/suites/$(image)/$(tag).xml --list-groups
	php ./vendor/bin/svrunit test --configuration=./tests/svrunit/suites/$(image)/$(tag).xml --debug --report-junit --report-html

# ----------------------------------------------------------------------------------------------------------------

release: ##2 Makes a new releasable version by generating, building and testing a specific image
	make generate -B
	make verify image=$(image) tag=$(tag) -B
	make build image=$(image) tag=$(tag) -B
	make test image=$(image) tag=$(tag) -B
