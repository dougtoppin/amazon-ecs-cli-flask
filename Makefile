# Makefile

PROJECT=flask
REPO=test
TAG=v1.0
PORT=5000
APPNAME=flask

# local docker build
build:
	docker build -t ${REPO}:${TAG} .

# local docker run, helpful for local testing before deploy,
# make sure that the ontainer runs, the app blocks
# and then make sure that from another window you can reach it with: curl localhost:5000
run:
	docker run -it --rm -p ${PORT}:${PORT} ${REPO}:${TAG}

# the normal usage of this would be as follows
# make init
# make app
# make fix-manifest
# make env
# make deploy
# make check
# make update
# make delete

# Alternatively, everything can be created with a single command as follows
# make all


# create a new project, note that this will put some metadata in the SSM Parameter Store and create a local directory
# called ecs-project
init:
	ecs-preview project init ${PROJECT}

# create the manifest with the application info, create an ecr repository for the image,
# note that after this step is when the manifest.yml file would be updated if your app
# does anything other than the default route and healthcheck
app:
	ecs-preview app init \
		--app-type 'Load Balanced Web App' \
		--dockerfile './Dockerfile' \
		--name ${APPNAME} \
		--port ${PORT}

# modify the generated manifest path and healthcheck endpoints to match the app route endpoints
fix-manifest:
	sed -i bak 's/^  path:.*/  path: api/' ecs-project/flask//manifest.yml
	sed -i bak 's/^  \# healthcheck:.*/  healthcheck: \/healthcheck/' ecs-project/flask//manifest.yml

# create ALB, IGW, subnets, routing tables, note that this will take at least a few minutes
env:
	ecs-preview env init --project ${PROJECT} --name test --profile default

# build, push and deploy the app
deploy:
	ecs-preview deploy


all: init app fix-manifest env deploy

# get the url and confirm that it is reacable, note that it might be a few minnutes before the app and healthcheck
# stabilizaes and reaches a healthy state
check:
	$(eval URL := $(shell ecs-preview app show --project ${PROJECT} --json | jq '.routes[].url'))
	@echo "url is: ${URL}"
	@curl ${URL}

# update the stack/app, note that source code changes must be in git
update:
	ecs-preview app deploy

# delete everything
delete:
	ecs-preview project delete --env-profiles 'test=default' --yes


# do everything in a single command
quick-deploy:
	ecs-preview init --project ${PROJECT} \
		--profile default \
		--app api \
		--app-type 'Load Balanced Web App' \
		--dockerfile './Dockerfile' \
		--port ${PORT} \
		--deploy
