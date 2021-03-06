REPO=gianlu33/reactive-uart2ip
TAG=latest

LOG	?= info

build:
	docker build -t $(REPO):$(TAG) .

push: build login
	docker push $(REPO):$(TAG)

pull:
	docker pull $(REPO):$(TAG)

run: check_port check_device
	docker run --network=host --device=$(DEVICE) --rm $(REPO):$(TAG) reactive-uart2ip -p $(PORT) -d $(DEVICE) -l $(LOG)

login:
	docker login

clean:
	docker rm $(shell docker ps -a -q) 2> /dev/null || true
	docker image prune -f

check_port:
	@test $(PORT) || (echo "PORT variable not defined. Run make <target> PORT=<port>" && return 1)

check_device:
	@test $(DEVICE) || (echo "DEVICE variable not defined. Run make <target> DEVICE=<device>" && return 1)
