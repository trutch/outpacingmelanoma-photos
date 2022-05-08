FROM ruby:2.4.3-stretch

RUN apt update

RUN apt install -y vim bash

# Copy all files to app dir
COPY . /app

# Set workdir to /app
WORKDIR /app

# Install dependencies
RUN bundle install

# Set a nicle little entrypoint
ENTRYPOINT /bin/bash
