FROM golang:alpine as builder

RUN GO111MODULE=on go get github.com/buildkite/terminal-to-html/v3/cmd/terminal-to-html

FROM ruby:3.0-alpine

COPY --from=builder /go/bin/terminal-to-html /usr/local/bin/terminal-to-html

# smoke test
RUN terminal-to-html --version
