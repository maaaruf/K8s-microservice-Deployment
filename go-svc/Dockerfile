FROM golang:1.21.5-alpine3.19 AS builder
WORKDIR /app
COPY go.mod .
RUN go mod tidy
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go-docker-demo .

FROM alpine:3.19
WORKDIR /app
COPY --from=builder /go-docker-demo .
EXPOSE 9090
CMD [ "./go-docker-demo" ]












# FROM golang:1.21.5-alpine3.19
# WORKDIR /app

# COPY go.mod .
# RUN go mod tidy

# COPY . .

# RUN go build -o /go-docker-demo

# EXPOSE 9090

# CMD [ "/go-docker-demo" ]