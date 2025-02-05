#!/usr/bin/env bash
#
# Generate all etcd protobuf bindings.
# Run from repository root directory named etcd.
#
set -ex

export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:~/go/bin/

# GRPC
protoc -I=".:./internal/vendor/proto" --go_out=./pkg  ./api/proto/v1/helloworld.proto
protoc -I=".:./internal/vendor/proto" --go-grpc_out=require_unimplemented_servers=false:./pkg  ./api/proto/v1/helloworld.proto

# GRPC Client
protoc -I=".:./internal/vendor/proto" --go_out=./api  ./api/proto/v1/helloworld.proto
protoc -I=".:./internal/vendor/proto" --go-grpc_out=require_unimplemented_servers=false:./api  ./api/proto/v1/helloworld.proto


# GRPC GW

protoc -I=".:./internal/vendor/proto" --grpc-gateway_out . \
       --grpc-gateway_opt logtostderr=true \
       --grpc-gateway_opt paths=source_relative \
       --grpc-gateway_opt generate_unbound_methods=true \
      ./api/proto/v1/helloworld.proto
mv ./api/proto/v1/helloworld.pb.gw.go ./pkg/helloworld

# OpenAPI

protoc -I=".:./internal/vendor/proto" --openapiv2_out=. ./api/proto/v1/helloworld.proto
mv ./api/proto/v1/helloworld.swagger.json ./api/swagger/v1/helloworld.swagger.json
cp ./api/swagger/v1/helloworld.swagger.json assets/swagger-ui/helloworld.swagger.json 

# Typescript

cd ./api/proto/v1/
protoc -I=".:./../../../internal/vendor/proto" --grpc-gateway-ts_out=. helloworld.proto
cd ../../../
mkdir -p ./api/ts
mv ./api/proto/v1/*.ts ./api/ts

cd ./internal/vendor/proto/google/protobuf/
protoc -I=".:./../../" --grpc-gateway-ts_out=. empty.proto
cd ../../../../../
mkdir -p ./api/ts/google/protobuf
mv ./internal/vendor/proto/google/protobuf/*.ts ./api/ts/google/protobuf
