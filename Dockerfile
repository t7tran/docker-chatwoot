FROM chatwoot/chatwoot:v1.20.0

ENV INSTALLATION_ENV=docker \
    NODE_ENV=production \
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    DISABLE_TELEMETRY=true

COPY ./rootfs /

RUN addgroup -g 1000 chatwoot && adduser -u 1000 -S -D -G chatwoot chatwoot && \
# make executables
    chmod +x /usr/local/bin/* && \
# alter default entrypoint
    sed -i 's/set -x/[[ -n "$DEBUG" ]] \&\& set -x/g' /app/docker/entrypoints/rails.sh && \
    sed -i '/exec "$@"/d' /app/docker/entrypoints/rails.sh && \
    grep -v /usr/bin/env /usr/local/bin/entrypoint >> /app/docker/entrypoints/rails.sh && \
# make peace for chatwoot user
    chown chatwoot:chatwoot /app/tmp && \
# clean up
    rm -rf /apk /tmp/* /var/cache/apk/*

USER chatwoot

ENTRYPOINT ["/app/docker/entrypoints/rails.sh"]
CMD []