.PHONY: help
.DEFAULT_GOAL := help


help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------------------------

install: ## Installs all dependencies
	npm install

clean: ## Cleans all dependencies
	rm -rf node_modules

# ---------------------------------------------------------------------------------------------

open-ui: ## Opens Cypress UI
ifndef url
	$(warning Please provide the URL argument to Start Cypress!)
	@exit 1
endif
	CYPRESS_BASE_URL=$(url) CYPRESS_SHOPWARE=$(shopware) ./node_modules/.bin/cypress open --env conf=dev

# ---------------------------------------------------------------------------------------------

run: ## Runs all E2E tests for Flex
ifndef url
	$(warning Please provide the URL argument to Start Cypress!)
	@exit 1
endif
	CYPRESS_BASE_URL=$(url) ./node_modules/.bin/cypress run --headless
