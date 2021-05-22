DOCKER=docker
BASE_IMAGE_NAME=coppelia_pyrep_uav_sac
BASE_DOCKERFILE=Dockerfile
CONTAINER_NAME=uav_sac_platforms

create-image:
	$(DOCKER) build -t $(BASE_IMAGE_NAME) .

create-container: 
	$(DOCKER) run -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --name $(CONTAINER_NAME) $(BASE_IMAGE_NAME)

training:
	xvfb-run sh training.sh
	
start-container:
	$(DOCKER) start -ia $(CONTAINER_NAME)

stop-container:
	$(DOCKER) container stop $(CONTAINER_NAME)

evaluate:
	sh evaluate.sh

evaluate-container:
	xvfb-run sh evaluate_container.sh

