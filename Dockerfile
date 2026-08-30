FROM python:3.12-slim
WORKDIR /app
COPY source2.zip /tmp/source2.zip
RUN apt-get update && apt-get install -y --no-install-recommends unzip \
    && unzip -q /tmp/source2.zip -d /app \
    && rm -rf /var/lib/apt/lists/* /tmp/source2.zip
RUN pip install --no-cache-dir -r backend/requirements.txt
ENV PYTHONPATH=/app/backend
EXPOSE 10000
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "10000"]
