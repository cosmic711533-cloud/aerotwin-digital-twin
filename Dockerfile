FROM python:3.12-slim
WORKDIR /app
COPY aerotwin-production.zip /tmp/app.zip
RUN apt-get update && apt-get install -y --no-install-recommends unzip \
    && unzip -q /tmp/app.zip -d /app \
    && rm -rf /var/lib/apt/lists/* /tmp/app.zip
RUN pip install --no-cache-dir -r backend/requirements.txt
RUN printf '%s\\n' '' 'from fastapi.responses import FileResponse' 'from .config import ROOT' '' 'FRONTEND_DIR = ROOT / "frontend" / "dist"' '' '@app.get("/{path:path}", include_in_schema=False)' 'def frontend(path: str) -> FileResponse:' '    requested = FRONTEND_DIR / path' '    if path and requested.is_file():' '        return FileResponse(requested)' '    return FileResponse(FRONTEND_DIR / "index.html")' >> backend/app/main.py
ENV PYTHONPATH=/app/backend
EXPOSE 10000
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "10000"]
