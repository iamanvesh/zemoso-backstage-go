
.PHONY: build clean test help default



BIN_NAME=zemoso-backstage-go-app

VERSION := $(shell grep "const Version " version/version.go | sed -E 's/.*"(.+)"$$/\1/')
GIT_COMMIT=$(shell git rev-parse HEAD)
GIT_DIRTY=$(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_DATE=$(shell date '+%Y-%m-%d-%H:%M:%S')
IMAGE_NAME := "guest/zemoso-backstage-go-app"

default: test

help:
	@echo 'Management commands for zemoso-backstage-go-app:'
	@echo
	@echo 'Usage:'
	@echo '    make build           Compile the project.'
	@echo '    make get-deps        runs dep ensure, mostly used for ci.'
	
	@echo '    make clean           Clean the directory tree.'
	@echo

build:
	@echo "building ${BIN_NAME} ${VERSION}"
	@echo "GOPATH=${GOPATH}"
	go build -ldflags "-X github.com/backstage/zemoso-backstage-go-app/version.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X github.com/backstage/zemoso-backstage-go-app/version.BuildDate=${BUILD_DATE}" -o bin/${BIN_NAME}

get-deps:
	dep ensure

clean:
	@test ! -e bin/${BIN_NAME} || rm bin/${BIN_NAME}

test:
	go test ./...

