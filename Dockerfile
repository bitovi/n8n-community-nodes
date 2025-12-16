ARG N8N_VERSION=1
FROM n8nio/n8n:${N8N_VERSION}

ARG N8N_VERSION=1
LABEL io.n8n.version.base="${N8N_VERSION}"

# Switch to the root user for installations
USER root

# === Python Dependencies for Alpine ===
# This uses Alpine's 'apk' package manager.
# 1. Create a temporary virtual package '.build-deps' with all build dependencies.
# 2. Use pip to install markitdown globally, adding '--break-system-packages' to handle PEP 668.
# 3. Ensure Python runtime packages remain installed.
# 4. Remove only the build dependencies to keep the image smaller.
RUN apk add --no-cache --virtual .build-deps git build-base python3-dev py3-pip && \
    apk add --no-cache python3 pandoc && \
    pip install markitdown --break-system-packages && \
    apk del .build-deps

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
