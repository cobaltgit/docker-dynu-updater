FROM alpine:3.14
COPY updater.sh /
RUN apk add bash curl --no-cache && chmod +x /updater.sh
ENTRYPOINT [ "/updater.sh" ]
