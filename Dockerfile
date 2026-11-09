# Image that serves the churn API. Same image is used for Hugging Face and Azure.
FROM python:3.11-slim

WORKDIR /app

# Install only the runtime dependencies (copied first for layer caching)
COPY requirements-serving.txt .
RUN pip install --no-cache-dir -r requirements-serving.txt

# Copy the API code and the trained model
COPY api/ ./api/
COPY models/ ./models/

# Hugging Face expects port 7860. Azure will be told to use the same port.
ENV PORT=7860
EXPOSE 7860

CMD ["sh", "-c", "uvicorn api.main:app --host 0.0.0.0 --port ${PORT}"]
