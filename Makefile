
CLUSTER_NAME=dummynictest

.PHONY: all
all: cluster app

.PHONY: clean
clean: app.clean cluster.clean

###############################################################################
# k3d cluster
###############################################################################
.PHONY: cluster
cluster: 
	k3d cluster create $(CLUSTER_NAME) --wait

.PHONY: cluster.clean
cluster.clean:
	k3d cluster delete $(CLUSTER_NAME)

###############################################################################
# Overall application deployment
###############################################################################
.PHONY: app
app: capture replay
	kubectl create -f app-deployment.yaml

.PHONY: app.clean
app.clean:
	kubectl delete -f app-deployment.yaml

###############################################################################
# Capture container
###############################################################################
.PHONY: capture
capture: capture.image

.PHONY: capture.image
capture.image: Dockerfile.capture
	docker build -f Dockerfile.capture -t jonfandrew/capture:latest .
	docker push jonfandrew/capture

###############################################################################
# Replay container
###############################################################################
.PHONY: replay
replay: replay.image

.PHONY: replay.image
replay.image: Dockerfile.replay replay.sh default.pcap
	docker build -f Dockerfile.replay -t jonfandrew/replay:latest .
	docker push jonfandrew/replay
