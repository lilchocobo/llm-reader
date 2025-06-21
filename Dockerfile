# ───────────────────────────────
# Dockerfile for llm-reader API
# ───────────────────────────────
FROM python:3.11-slim

# Where everything will live
WORKDIR /app

# ── 1. OS-level deps (only what Selenium needs) ───────────────────
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        chromium \
        chromium-driver && \
    rm -rf /var/lib/apt/lists/*

# ── 2. Python deps ────────────────────────────────────────────────
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ── 3. Copy code & install your package so imports work ───────────
COPY . /app
RUN pip install --no-cache-dir -e .

# ── 4. Environment variables ──────────────────────────────────────
ENV CHROME_BIN=/usr/bin/chromium \
    CHROMEDRIVER_BIN=/usr/bin/chromedriver \
    PYTHONUNBUFFERED=1

# ── 5. Expose & launch ────────────────────────────────────────────
EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
