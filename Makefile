IMAGE_NAME=ssh_example_image
CONTAINER_NAME=ssh_example_container
HOST_PORT=9999

build:
	docker build -t $(IMAGE_NAME) -f Dockerfile .

run:
	docker run --runtime=nvidia \
		-d \
		-p ${HOST_PORT}:22 \
		--name $(CONTAINER_NAME) \
		-v $(shell pwd):/pycharm-docker-via-ssh \
		$(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME) && docker rm $(CONTAINER_NAME)