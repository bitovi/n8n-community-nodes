ARG N8N_VERSION=latest

# Stage 1: install all packages in an Alpine image that still has apk
FROM alpine:3.19 AS apk-builder
ARG INSTALL_ROOT=/opt/runtime

RUN set -eux; \
    mkdir -p "${INSTALL_ROOT}"; \
    mkdir -p "${INSTALL_ROOT}/etc"; \
    cp -L /etc/resolv.conf "${INSTALL_ROOT}/etc/resolv.conf"; \
    cp -L /etc/hosts "${INSTALL_ROOT}/etc/hosts"; \
    apk --root "${INSTALL_ROOT}" --keys-dir /etc/apk/keys --repositories-file /etc/apk/repositories --initdb add --no-cache python3 py3-pip pandoc && \
    apk --root "${INSTALL_ROOT}" --keys-dir /etc/apk/keys --repositories-file /etc/apk/repositories add --no-cache --virtual .build-deps git build-base python3-dev && \
    chroot "${INSTALL_ROOT}" /usr/bin/pip install markitdown --break-system-packages && \
    apk --root "${INSTALL_ROOT}" del .build-deps && \
    rm -rf "${INSTALL_ROOT}/var/cache/apk"

# Stage 2: start from upstream n8n image and layer the packages from the builder
FROM n8nio/n8n:${N8N_VERSION}

ARG N8N_VERSION=latest
LABEL io.n8n.version.base="${N8N_VERSION}"

# Switch to the root user for installations
USER root

# Copy the runtime files that were installed with apk in the builder stage
COPY --from=apk-builder /opt/runtime/ /

# Ensure the Python scripts directory is in PATH for all users
ENV PATH="/usr/local/bin:$PATH"

# Install global dependencies and set up directories in single layer
RUN npm i -g child_process date-fns fs-extra tmp-promise jszip css-to-xpath wikipedia langfuse

USER node
WORKDIR /home/node/.n8n/nodes

# Install all packages with npm (not pnpm), ignoring preinstall scripts
RUN npm install --only=prod --ignore-scripts \
    @bitovi/n8n-nodes-confluence@latest \
    @bitovi/n8n-nodes-excel@latest \
    @bitovi/n8n-nodes-freshbooks@latest \
    @bitovi/n8n-nodes-google-search@latest \
    @bitovi/n8n-nodes-langfuse@latest \
    @bitovi/n8n-nodes-markitdown@latest \
    @bitovi/n8n-nodes-semantic-text-splitter@latest \
    @bitovi/n8n-nodes-utils@latest \
    @bitovi/n8n-nodes-watsonx@latest

# Ensure proper permissions
USER root
RUN chown -R node:node /home/node/.n8n/nodes

USER node
WORKDIR /home/node
