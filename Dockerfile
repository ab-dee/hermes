# Use the official minimal Ubuntu image
FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install core dependencies
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    python3 \
    python3-pip \
    python3-venv \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install the Hermes Agent via the official script
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Ensure the installed binary is in the system PATH
ENV PATH="/root/.local/bin:$PATH"

# Set the working directory for persistent data
WORKDIR /data

# Set Hermes as the default execution command
ENTRYPOINT ["hermes"]
