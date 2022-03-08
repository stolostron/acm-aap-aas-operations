FROM registry.ci.openshift.org/stolostron/builder:go1.17-linux AS builder

WORKDIR /workspace

COPY go.sum go.mod ./

COPY metric-simulator.go ./

RUN CGO_ENABLED=0 go build -a -installsuffix cgo -v -i -o metric-simulator metric-simulator.go

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

WORKDIR /

COPY --from=builder /workspace/metric-simulator metric-simulator

ENTRYPOINT ["/metric-simulator"]
