DOCKER_RUN = docker run --rm -v "$$(pwd):/app" -w /app php:8.4-cli
PHEL       = $(DOCKER_RUN) vendor/bin/phel
COMPOSER   = docker run --rm -v "$$(pwd):/app" -w /app composer:latest composer

.PHONY: help install test repl list add done remove clear debug format

help: ## Show this help
	@echo ""
	@echo "  Phel Todo - Makefile commands"
	@echo "  ============================="
	@echo ""
	@echo "  App commands:"
	@echo "    make list              - Show all todos"
	@echo "    make add TEXT=\"...\"     - Add a new todo"
	@echo "    make done ID=1         - Toggle todo done/undone"
	@echo "    make remove ID=1       - Remove a todo"
	@echo "    make clear             - Remove all completed todos"
	@echo "    make debug             - Pretty-print raw todo data"
	@echo ""
	@echo "  Dev commands:"
	@echo "    make install           - Install dependencies"
	@echo "    make test              - Run tests"
	@echo "    make repl              - Start Phel REPL"
	@echo "    make format            - Format Phel source files"
	@echo ""

install: ## Install composer dependencies
	$(COMPOSER) install --no-interaction

test: ## Run Phel tests
	$(PHEL) test

repl: ## Start Phel REPL
	$(DOCKER_RUN) -it vendor/bin/phel repl

format: ## Format Phel source files
	$(PHEL) format

list: ## List all todos
	$(PHEL) run src/main.phel list

add: ## Add a todo: make add TEXT="Buy groceries"
	$(PHEL) run src/main.phel add $(TEXT)

done: ## Toggle todo done/undone: make done ID=1
	$(PHEL) run src/main.phel done $(ID)

remove: ## Remove a todo: make remove ID=1
	$(PHEL) run src/main.phel remove $(ID)

clear: ## Clear all completed todos
	$(PHEL) run src/main.phel clear

debug: ## Pretty-print raw todo data
	$(PHEL) run src/main.phel debug
