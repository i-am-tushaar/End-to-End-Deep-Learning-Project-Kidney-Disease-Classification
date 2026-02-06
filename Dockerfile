# Base image
FROM python:3.10-slim

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install system dependencies and AWS CLI v2
RUN apt-get update \
    && apt-get install -y curl unzip ca-certificates \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws /var/lib/apt/lists/*

# Verify AWS CLI installation
RUN aws --version

# Copy requirements first (for caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port (change if needed)
EXPOSE 5000

# Start the application (adjust if needed)
CMD ["python", "app.py"]
