# Use Python base image with good wheel support
FROM python:3.10-slim-bookworm

# Install dependencies and Rust
RUN apt-get update && apt-get install -y curl build-essential python3-dev git && \
    curl https://sh.rustup.rs -sSf | bash -s -- -y

# Set PATH so future RUN steps can find cargo
ENV PATH="/root/.cargo/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy your project into the container
COPY . /app

# Install the package (and its dependencies)
RUN pip install --no-cache-dir .

# Pre-download sentence-transformers model
RUN mkdir -p /app/models && \
    python -c "from sentence_transformers import SentenceTransformer; \
    model = SentenceTransformer('all-MiniLM-L6-v2'); \
    model.save('/app/models/all-MiniLM-L6-v2')"

# No need for CMD or ENTRYPOINT if you're using stdio mode
