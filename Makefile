IMAGE_NAME ?= mehedi02/poridhi
TAG ?= $$TAG

.PHONY: all

all: docker-build-go docker-build-node docker-build-dotnet docker-build-client clean-docker-config

docker-login:
	@docker login -u $$DOCKER_USERNAME -p $$DOCKER_PASSWORD

docker-build-go: docker-login
	@docker image build -t $(IMAGE_NAME)-go:$(TAG) ./go-svc
	@docker push $(IMAGE_NAME)-go:$(TAG)

docker-build-node: docker-login
	@docker image build -t ${IMAGE_NAME}-node:${TAG} ./node-svc
	@docker push ${IMAGE_NAME}-node:${TAG}

docker-build-dotnet: docker-login
	@docker image build -t ${IMAGE_NAME}-dotnet:${TAG} ./dotnet-svc
	@docker push ${IMAGE_NAME}-dotnet:${TAG}

docker-build-client: docker-login
	@docker image build -t ${IMAGE_NAME}-client:${TAG} ./frontend
	@docker push ${IMAGE_NAME}-client:${TAG}

clean-docker-config: docker-login docker-build-go docker-build-node docker-build-dotnet docker-build-client
	@rm -f /home/runner/.docker/config.json