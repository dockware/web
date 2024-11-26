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
	composer install

clear: ##1 Clears all dependencies dangling images
	rm -rf vendor/*
	rm -rf node_modules/*
	docker images -aq -f 'dangling=true' | xargs docker rmi
	docker volume ls -q -f 'dangling=true' | xargs docker volume rm

# ----------------------------------------------------------------------------------------------------------------

build: ##2 Builds the image
ifndef version
	$(error Please provide the argument version=xyz to run the command)
endif
	@cd ./src && time DOCKER_BUILDKIT=1 docker build --build-arg IMAGE_VERSION=$(version) -t dockware/flex:$(version) .

analyze: ##2 Shows the size of the image
ifndef version
	$(error Please provide the argument version=xyz to run the command)
endif
	docker history --format "{{.CreatedBy}}\t\t{{.Size}}" dockware/flex:$(version) | grep -v "0B"
	# --------------------------------------------------
	docker save -o flex.tar dockware/flex:$(version)
	gzip flex.tar
	ls -lh flex.tar.gz
	# --------------------------------------------------
	rm -rf flex.tar
	rm -rf flex.tar.gz | true

# ----------------------------------------------------------------------------------------------------------------

test: ##3 Runs all SVRUnit tests
ifndef version
	$(error Please provide the argument version=xyz to run the command)
endif
	time php ./vendor/bin/svrunit test --configuration=./tests/svrunit/flex.xml --docker-tag=$(version) --debug --report-junit --report-html
