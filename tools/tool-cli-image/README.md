
We can use this image to create a pod in the cluster and debug something because sometimes we want to debug some issues in the cluster, but the pod does have not a tool command.

## Command List

- git
- iputils 
- jq 
- kubectl
- make 
- oc
- tar

## Build & Push Image

```
$ docker build -t quay.io/acm-sre/tool-cli -f Dockerfile .
$ docker push quay.io/acm-sre/tool-cli:latest
```

## Create Pod in Cluster

```
kubectl run -it debug-pod --image=quay.io/acm-sre/tool-cli:latest
```
