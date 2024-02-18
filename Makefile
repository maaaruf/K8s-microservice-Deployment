IMAGE_NAME ?= mehedi02/poridhi
TAG ?= v1

.PHONY: all

all: docker-build-go docker-build-node docker-build-dotnet docker-build-client

docker-build-go:
	@ docker image build -t $(IMAGE_NAME)-go:$(TAG) -f go-svc/Dockerfile .

docker-build-node:
	@ docker image build -t ${IMAGE_NAME}-node:${TAG} ./node-svc

docker-build-dotnet:
	@ docker image build -t ${IMAGE_NAME}-dotnet:${TAG} ./dotnet-svc/PaymentService

docker-build-client:
	@ docker image build -t ${IMAGE_NAME}-client:${TAG} ./frontend
