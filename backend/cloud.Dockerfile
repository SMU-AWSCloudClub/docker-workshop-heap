FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy wait-for-it script
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

CMD ["/wait-for-it.sh", "db:3306", "--", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080", "--ssl-keyfile", "/app/ssl/books.bchwy.com.key", "--ssl-certfile", "/app/ssl/books.bchwy.com.crt"]