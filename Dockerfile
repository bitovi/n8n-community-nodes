ARG N8N_VERSION=latest
FROM n8nio/n8n:${N8N_VERSION}

ARG N8N_VERSION=latest
LABEL io.n8n.version.base="${N8N_VERSION}"

# Switch to the root user for installations
USER root

# Reinstall apk-tools since some upstream images remove it
# Exit 0 to continue even if this fails for very old base images
RUN ARCH=$(uname -m) && \
    (wget -qO- "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" | \
    grep -o 'href="apk-tools-static-[^"]*\.apk"' | head -1 | cut -d'"' -f2 | \
    xargs -I {} wget -q "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/{}" && \
    tar -xzf apk-tools-static-*.apk && \
    ./sbin/apk.static -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/main \
        -U --allow-untrusted add apk-tools && \
    rm -rf sbin apk-tools-static-*.apk) || echo "Warning: Could not reinstall apk-tools, using existing version"

# Install Python dependencies for markitdown (optional for compatibility with older versions)
# If this fails on older base images, we continue without markitdown support
RUN (apk add --no-cache --virtual .build-deps git build-base python3-dev py3-pip && \
    apk add --no-cache python3 pandoc && \
    pip install markitdown --break-system-packages && \
    apk del .build-deps) || echo "Warning: Could not install markitdown dependencies (likely older base image). Continuing without markitdown support."

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
