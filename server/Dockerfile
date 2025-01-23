##########################################
# build base image
##########################################
FROM python:3.11.9-slim as builder

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin/:$PATH" \
    UV_PROJECT_ENVIRONMENT="/usr/local/"

WORKDIR /workspace
COPY pyproject.toml uv.lock ./
COPY ./libs/hoge-lib /workspace/libs/hoge-lib
RUN uv sync --frozen --no-dev --no-editable

##########################################
# build deploy image
##########################################
FROM python:3.11.9-slim

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    libmagic-dev \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1
ENV TZ Asia/Tokyo

WORKDIR /workspace
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

COPY ./app /workspace/app/
CMD ["gunicorn", "--config", "/workspace/app/gunicorn.conf.py"]