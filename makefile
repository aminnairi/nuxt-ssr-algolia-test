.PHONY: install start stop restart mrproper

install:
	docker-compose run --rm node npm install

start:
	docker-compose up --detach

stop:
	docker-compose down --remove-orphans --volumes

restart: stop start

mrproper:
	for file in $(shell cat ./.gitignore); do rm -rf $$file; done
