#!/bin/bash

UID = $(shell id -u)
DOCKER_BE = appstarter-be
DOCKER_FE = appstarter-fe

help: ## Muestra la ayuda
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

# Gestión de contenedores

build: ## Reconstruye todos los contenedores
	@U_ID=${UID} docker-compose build

start: ## Inicia los contenedores
	@U_ID=${UID} docker-compose up -d

stop: ## Para los contenedores
	@U_ID=${UID} docker-compose stop

down: ## Apaga los contenedores
	@U_ID=${UID} docker-compose down

restart: ## Reinicia los contenedores
	@$(MAKE) stop && $(MAKE) start

ssh-be: ## Inicia bash en el contenedor de backend
	@U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} bash

# Gestión de dependencias
composer-install: ## Instala las dependencias de composer
	@U_ID=${UID} docker exec --user ${UID} ${DOCKER_BE} composer install --no-interaction

# Comandos de desarrollo
serve: ## Inicia el servidor de desarrollo de Codeigniter
	@U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} php spark serve

cache-clear: ## Limpia la cache
	@U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} php spark cache:clear

cache-info: ## Muestra información de la caché
	@U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} php spark cache:info

yarn-watch: ## Ejecuta yarn-watch
	@U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} yarn watch
