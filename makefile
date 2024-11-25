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

build: ##2 Builds the image
	@cd ./src && time DOCKER_BUILDKIT=1 docker build --build-arg IMAGE_VERSION=2.0.0 --build-arg IMAGE_TAG=dev-main -t dockware/flex:dev-main .

analyze: ##2 Shows the size of the image
	rm -rf tmp-image.tar.gz | true
	docker history --format "{{.CreatedBy}}\t\t{{.Size}}" dockware/flex:dev-main | grep -v "0B"
	docker save -o tmp-image.tar dockware/flex:dev-main
	gzip tmp-image.tar
	ls -lh tmp-image.tar.gz
	rm -rf tmp-image.tar
	rm -rf ./src/tmp-image.tar.gz
	docker run --rm -it dockware/flex:dev-main dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n -r | head -20


# ----------------------------------------------------------------------------------------------------------------

verify: ##3 Verify the configuration
	php ./build/Scripts/verify-config.php flex dev-main

test: ##3 Runs all SVRUnit Test Suites for the provided image and tag
	# php ./vendor/bin/svrunit test --configuration=./tests/svrunit/flex.xml --list-suites
	# php ./vendor/bin/svrunit test --configuration=./tests/svrunit/flex.xml --list-groups
	time php ./vendor/bin/svrunit test --configuration=./tests/svrunit/flex.xml --docker-tag=dev-main --debug --report-junit --report-html
