FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# Install system dependencies needed for pip packages
RUN apt-get update \
    && apt-get install -y \
       build-essential \
       gcc \
       curl \
       unzip \
       ca-certificates \
       libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Copy requirements first
COPY requirements.txt .

# Upgrade pip tools (VERY IMPORTANT)
RUN pip install --upgrade pip setuptools wheel

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the app
COPY . .

EXPOSE 5000
CMD ["python", "app.py"]
