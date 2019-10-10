.PHONY: start stop restart

start:
	docker-compose up --detach

stop:
	docker-compose down --remove-orphans --volumes

restart: stop start
