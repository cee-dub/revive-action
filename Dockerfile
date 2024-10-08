FROM golang:1.23.0 as build-env

ARG ACTION_VERSION=unknown
ARG REVIVE_VERSION=v1.3.9

ENV CGO_ENABLED=0

RUN go install -v -ldflags="-X 'main.version=${REVIVE_VERSION}'" \
    github.com/mgechev/revive@${REVIVE_VERSION}

WORKDIR /tmp/github.com/morphy2k/revive-action
COPY . .

RUN go install -ldflags="-X 'main.version=${ACTION_VERSION}'"

FROM golang:1.23.0-alpine

LABEL repository="https://github.com/cee-dub/revive-action"
LABEL homepage="https://github.com/cee-dub/revive-action"

LABEL com.github.actions.name="Revive Action"
LABEL com.github.actions.description="Lint Go code with Revive"
LABEL com.github.actions.icon="code"
LABEL com.github.actions.color="blue"

COPY --from=build-env ["/go/bin/revive", "/go/bin/revive-action", "/bin/"]
COPY --from=build-env /tmp/github.com/morphy2k/revive-action/entrypoint.sh /

RUN apk add --no-cache bash

ENTRYPOINT ["/entrypoint.sh"]
