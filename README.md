# Bitovi n8n Community Nodes

Welcome to the official Bitovi repo for our community [n8n](https://n8n.io) nodes!

This repository contains custom n8n nodes built and maintained by [Bitovi](https://www.bitovi.com/) to extend the functionality of your workflows. Each node is packaged individually and can be used independently. The Docker image managed by this repository includes all of Bitovi's custom n8n nodes.

## Packages

Our Docker image includes the following Bitovi n8n community nodes:

- **[`n8n-nodes-confluence`](https://github.com/bitovi/n8n-nodes-confluence)**  
  N8N node to work with Atlassian's Confluence.

- **[`n8n-nodes-excel`](https://github.com/bitovi/n8n-nodes-excel)**  
  N8N node to work with Excel files.

- **[`n8n-nodes-freshbooks`](https://github.com/bitovi/n8n-nodes-freshbooks)**  
  N8N node to work with Freshbooks.

- **[`n8n-nodes-google-search`](https://github.com/bitovi/n8n-nodes-google-search)**  
  N8N node to work with Google Search.

- **[`n8n-nodes-langfuse`](https://github.com/bitovi/n8n-nodes-langfuse)**  
  N8N node to work with Langfuse.

- **[`n8n-nodes-markitdown`](https://github.com/bitovi/n8n-nodes-markitdown)**  
  N8N community node that integrates with Microsoft's Markitdown tool for converting various document formats into structured Markdown.

- **[`n8n-nodes-semantic-text-splitter`](https://github.com/bitovi/n8n-nodes-semantic-text-splitter)**  
  N8N node for semantic text splitting according to 5 Levels Of Text Splitting.

- **[`n8n-nodes-utils`](https://github.com/bitovi/n8n-nodes-utils)**  
  N8N util nodes from Bitovi.

- **[`n8n-nodes-watsonx`](https://github.com/bitovi/n8n-nodes-watsonx)**  
  N8N community package that provides a node to integrate your workflows with IBM's watsonx.ai platform.

## Usage

Get started quickly with our pre-built Docker image that includes all Bitovi community nodes. The image is available on [Docker Hub](https://hub.docker.com/r/bitovi/n8n-community-nodes) and can be used in two ways:

### Option 1: Use as Base Image
```dockerfile
FROM bitovi/n8n-community-nodes
# Add your custom configurations here
```

### Option 2: Direct Deployment
```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  bitovi/n8n-community-nodes
```

**Docker Hub Repository:** [`bitovi/n8n-community-nodes`](https://hub.docker.com/r/bitovi/n8n-community-nodes)

## Image Management

### Automated Builds
- GitHub Actions checks hourly for new n8n versions and node package updates
- Automatically rebuilds and publishes the Docker image when updates are detected
- Images are tagged with `latest` and version-specific tags

## Contributing

We welcome community contributions! Please open an issue or submit a PR if you'd like to suggest a new node, report a bug, or improve an existing integration.

## License

MIT License © [Bitovi](https://www.bitovi.com/)



<a href="https://www.bitovi.com/n8n-automation-consulting" target="_blank">
  <img src="assets/bitovi-blurb.png" alt="Built better by Bitovi" width="300"/>
</a>
