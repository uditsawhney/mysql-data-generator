FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install mysql-connector-python prometheus_client
CMD ["python", "main.py"]
