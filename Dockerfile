FROM python:3.11-slim

WORKDIR /app

# ---- system deps (only what Selenium needs) ----------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        chromium \
        chromium-driver && \
    rm -rf /var/lib/apt/lists/*

# ---- python deps --------------------------------------------------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- copy code & expose port -------------------------------------
COPY . /app
ENV CHROME_BIN=/usr/bin/chromium \
    CHROMEDRIVER_BIN=/usr/bin/chromedriver \
    PYTHONUNBUFFERED=1
EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
