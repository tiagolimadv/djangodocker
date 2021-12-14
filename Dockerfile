# sintax=docker/dockerfile:1

FROM python:alpine3.15

RUN mkdir -p /home/app/wheels

ENV APP_HOME=/home/app

WORKDIR $APP_HOME

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk add --update --no-cache --virtual .tmp-build-deps \
	gcc python3-dev postgresql-dev musl-dev libpq

COPY ["./requirements.txt", "./entrypoint.sh", "./"]
RUN pip install --upgrade pip && \
	pip wheel --no-cache-dir --no-deps --wheel-dir $APP_HOME/wheels -r requirements.txt && \
	pip install --no-cache $APP_HOME/wheels/*

COPY . $APP_HOME

RUN addgroup -S app && \
	adduser -S app -G app && \
	chown -R app:app $APP_HOME

USER app

ENTRYPOINT ["sh", "./entrypoint.sh"]