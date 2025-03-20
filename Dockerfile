FROM arm64v8/ubuntu:latest

# Install core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    ca-certificates \
    nodejs \
    npm


# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.83.0
# RUN rustup toolchain install 1.83.0
ENV PATH="/root/.cargo/bin:${PATH}"

# Add WASI target
RUN rustup target add wasm32-wasi

# Install Cargo Generate
RUN cargo install --locked cargo-generate

# Install Anypoint CLI v4 using npm
RUN npm install -g anypoint-cli-v4

# Install Anypoint CLI PDK Plugin
RUN anypoint-cli-v4 plugins:install anypoint-cli-pdk-plugin


# # Create a non-root user for development
# RUN groupadd -g 1001 devuser && \
#     useradd -u 1001 -g devuser -s /bin/bash devuser && \
#     mkdir -p /home/devuser && \
#     chown -R devuser:devuser /home/devuser
    
# USER devuser
WORKDIR /root

# Set the PATH for the non-root user
# ENV PATH="/home/devuser/.cargo/bin:/usr/local/bin:${PATH}"

# Informational labels
LABEL maintainer="Saurav Upadhyaya <saurav.upadhyaya@gmail.com>"
LABEL description="Devcontainer for Flex Gateway PDK development"

# Example command (optional)
CMD ["bash"]