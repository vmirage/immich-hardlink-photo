FROM python:3.12-slim

# system deps (needed for psycopg2 + filesystem ops)
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# default envs (can be overridden)
ENV SYNC_INTERVAL=30
ENV SQLITE_DB=/data/sync.db

# run
CMD ["python", "-u", "main.py"]