FROM python:3.6-stretch

ENV PYTHONUNBUFFERED 1

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && rm -rf /var/lib/apt/lists/*

# Requirements are installed here to ensure they will be cached.
COPY ./Python3.6/requirements.txt /requirements.txt
RUN pip install --upgrade pip \
    &&pip install --no-cache-dir -r /requirements.txt\
    && rm /requirements.txt

COPY ./Python3.6/start /start
RUN sed -i 's/\r//' /start
RUN chmod +x /start
