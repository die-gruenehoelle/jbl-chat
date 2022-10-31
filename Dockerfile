FROM python:3.9.15-slim-bullseye

EXPOSE 8000

ENTRYPOINT ["custom-entrypoint.sh"]
CMD ["gunicorn"]

ARG DEBIAN_FRONTEND="noninteractive"

ENV PYTHONUNBUFFERED="1" \
    PYTHONDONTWRITEBYTECODE="1" \
    GUNICORN_CMD_ARGS="--bind=0.0.0.0" \
    PATH="${PATH}:/app/.local/bin"

RUN set -ex && \
    apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
      bash \
      default-libmysqlclient-dev \
      gcc && \
    useradd -d /app -m -s /bin/bash app

COPY bin/ /usr/local/bin/

USER app
WORKDIR /app

COPY --chown=app:app requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY --chown=app:app . .
