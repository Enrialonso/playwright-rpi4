SHELL=/bin/bash

build:
	docker build --pull --rm -t playwright-docker-python .

run:
	docker run --rm -it --name playwright-docker-python playwright-docker-python