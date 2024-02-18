IMAGE_NAME:=${IMAGE_NAME}
TAG:=${TAG}

docker-build:
	@ docker image build -t ${IMAGE_NAME}:{TAG} .