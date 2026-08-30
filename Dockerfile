FROM node:20-alpine AS frontend-build
WORKDIR /app
COPY source.zip /tmp/source.zip
RUN apk add --no-cache unzip && unzip -q /tmp/source.zip -d /app
RUN cd frontend && npm ci && npm run build

FROM python:3.12-slim
WORKDIR /app
COPY source.zip /tmp/source.zip
RUN apt-get update && apt-get install -y --no-install-recommends unzip \
    && unzip -q /tmp/source.zip -d /app \
    && rm -rf /var/lib/apt/lists/* /tmp/source.zip
RUN pip install --no-cache-dir -r backend/requirements.txt
COPY --from=frontend-build /app/frontend/dist frontend/dist
ENV PYTHONPATH=/app/backend
EXPOSE 10000
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "10000"]
