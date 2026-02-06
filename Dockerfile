FROM python:3.10-slim

WORKDIR /app

# 🔴 THIS IS THE KEY FIX
ENV PYTHONPATH=/app/src

RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1 \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8080
CMD ["python", "app.py"]
