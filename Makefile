run:
	docker run \
	--rm \
	-d \
	--name webhook \
	-v ./docker_webhook:/usr/app/docker_webhook \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-p 127.0.0.1:8321:8000 \
	eugeneparkhom/webhook:latest 

build:
	mkdir dist
	cp Makefile ./dist/
	cp -r ./docker_webhook ./dist/

test:
	~/.local/share/pypoetry/venv/bin/poetry run pytest
