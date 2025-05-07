# Use Python base image with prebuilt wheels
FROM python:3.10-slim-bookworm

# Set working directory
WORKDIR /app

# Install build tools (no Rust needed if wheels are available)
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    python3-dev \
    git \
 && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . /app

# Upgrade pip-related tools
RUN pip install --upgrade pip setuptools wheel

# Install the tool and dependencies (setuptools will handle src layout)
RUN pip install .

# Preload the sentence-transformers model
RUN mkdir -p /app/models && \
    python -c "from sentence_transformers import SentenceTransformer; \
    model = SentenceTransformer('all-MiniLM-L6-v2'); \
    model.save('/app/models/all-MiniLM-L6-v2')"

# No ENTRYPOINT if using via stdio
