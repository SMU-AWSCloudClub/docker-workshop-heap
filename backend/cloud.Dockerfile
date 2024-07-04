# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Install necessary build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-mysql-client \
    libmariadb-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app
COPY . /app

# Upgrade pip and install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt --verbose

EXPOSE 8080

# Add a script to wait for the database and then start the application
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

CMD ["/wait-for-it.sh", "db:3306", "--", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080", "--ssl-keyfile", "/app/ssl/books.bchwy.com.key", "--ssl-certfile", "/app/ssl/books.bchwy.com.crt"]
