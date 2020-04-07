FROM alpine:latest

RUN apk update
RUN apk add python3 py-pip

RUN adduser -D app

COPY requirements.txt /home/app/
COPY app.py /home/app/

RUN pip3 install -r /home/app/requirements.txt

RUN chown -R app:app /home/app/

ENV HOME=/home/app

USER app
WORKDIR /home/app

ENTRYPOINT python3 /home/app/app.py