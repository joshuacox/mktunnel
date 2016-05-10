.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

tunnel: run

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: NAME TAG MONITOR_PORT LOCAL_PORT FORWARDED_PORT REMOTE_PORT REMOTE_USER REMOTE_HOST builddocker

# run a plain container
run: build rundocker

rundocker: runprod

runprod: tunnelCID

tunnelCID:
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval MONITOR_PORT := $(shell cat MONITOR_PORT))
	$(eval FORWARDED_PORT := $(shell cat FORWARDED_PORT))
	$(eval LOCAL_PORT := $(shell cat LOCAL_PORT))
	$(eval REMOTE_USER := $(shell cat REMOTE_USER))
	$(eval REMOTE_HOST := $(shell cat REMOTE_HOST))
	$(eval REMOTE_PORT := $(shell cat REMOTE_PORT))
	$(eval KEYS := $(shell cat KEYS))
	$(eval PORTS := $(shell cat PORTS))
	@docker run --name=$(NAME) \
	--cidfile="tunnelCID" \
	-d \
	-e "MONITOR_PORT=$(MONITOR_PORT)" \
	-e "FORWARDED_PORT=$(FORWARDED_PORT)" \
	-e "LOCAL_PORT=$(LOCAL_PORT)" \
	-e "REMOTE_PORT=$(REMOTE_PORT)" \
	-e "REMOTE_USER=$(REMOTE_USER)" \
	-e "REMOTE_HOST=$(REMOTE_HOST)" \
	$(PORTS) \
	-v $(KEYS):/root/keys \
	-t $(TAG)

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat tunnelCID`

rm-image:
	-@docker rm `cat tunnelCID`
	-@rm tunnelCID

rm: kill rm-image

clean: rm

enter:
	docker exec -i -t `cat tunnelCID` /bin/bash

logs:
	docker logs -f `cat tunnelCID`

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;

MONITOR_PORT:
	@while [ -z "$$MONITOR_PORT" ]; do \
		read -r -p "Enter the monitoring port you wish to associate with this container [MONITOR_PORT]: " MONITOR_PORT; echo "$$MONITOR_PORT">>MONITOR_PORT; cat MONITOR_PORT; \
	done ;

FORWARDED_PORT:
	@while [ -z "$$FORWARDED_PORT" ]; do \
		read -r -p "Enter the FORWARDED_PORT you wish to associate with this container [FORWARDED_PORT]: " FORWARDED_PORT; echo "$$FORWARDED_PORT">>FORWARDED_PORT; cat FORWARDED_PORT; \
	done ;

LOCAL_PORT:
	@while [ -z "$$LOCAL_PORT" ]; do \
		read -r -p "Enter the LOCAL_PORT you wish to associate with this container [LOCAL_PORT]: " LOCAL_PORT; echo "$$LOCAL_PORT">>LOCAL_PORT; cat LOCAL_PORT; \
	done ;

REMOTE_PORT:
	@while [ -z "$$REMOTE_PORT" ]; do \
		read -r -p "Enter the REMOTE_PORT you wish to associate with this container [REMOTE_PORT]: " REMOTE_PORT; echo "$$REMOTE_PORT">>REMOTE_PORT; cat REMOTE_PORT; \
	done ;

REMOTE_HOST:
	@while [ -z "$$REMOTE_HOST" ]; do \
		read -r -p "Enter the REMOTE_HOST you wish to associate with this container [REMOTE_HOST]: " REMOTE_HOST; echo "$$REMOTE_HOST">>REMOTE_HOST; cat REMOTE_HOST; \
	done ;

REMOTE_USER:
	@while [ -z "$$REMOTE_USER" ]; do \
		read -r -p "Enter the REMOTE_USER you wish to associate with this container [REMOTE_USER]: " REMOTE_USER; echo "$$REMOTE_USER">>REMOTE_USER; cat REMOTE_USER; \
	done ;
