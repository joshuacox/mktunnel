.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs


all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: NAME TAG builddocker

# run a plain container
run: build rundocker

rundocker: runprod

runprod: tunnelCID

tunnelCID:
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval KEYS := $(shell cat KEYS))
	$(eval PORTS := $(shell cat PORTS))
	@docker run --name=$(NAME) \
	--cidfile="tunnelCID" \
	-d \
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

