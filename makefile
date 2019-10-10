.PHONY: install start stop restart

install:
	docker-compose run --rm node npm install

start:
	docker-compose up --detach

stop:
	docker-compose down --remove-orphans --volumes

restart: stop start
