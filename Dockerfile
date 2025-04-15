FROM ruby:3.3.4-slim-bookworm

ARG arch=x64
ARG user=tester

ENV HOME=/home/code
ENV NODE_VERSION=22.6.0
ENV EDITOR=vim GIT_EDITOR=vim
# Reduce memory usage of Ruby processes
ENV MALLOC_ARENA_MAX=2
ENV RACK_ENV=development RAILS_ENV=development

CMD ["tail", "-f", "/dev/null"]

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev nodejs default-libmysqlclient-dev

RUN adduser --disabled-password --gecos '' ${user} && \
    usermod -aG sudo ${user}

USER ${user}

WORKDIR /home/code
