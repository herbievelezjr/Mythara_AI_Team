# Mythara AI Team orchestrator
# Build: docker build -t mythara-ai-team .
# Run:   docker run -p 5000:5000 -e MYTHARA_API_KEYS='{"key": {"name": "Ops", "roles": ["read", "invoke", "admin"]}}' mythara-ai-team
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

EXPOSE 5000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]
