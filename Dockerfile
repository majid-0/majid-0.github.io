FROM ruby:latest
ENV DEBIAN_FRONTEND noninteractive

LABEL MAINTAINER Amir Pourmand

# Install necessary packages
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    locales \
    imagemagick \
    build-essential \
    zlib1g-dev \
    jupyter-nbconvert \
    inotify-tools \
    procps \
    curl \
    nodejs \
    npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Generate locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production

# Create the working directory
RUN mkdir /srv/jekyll
WORKDIR /srv/jekyll

# Copy Gemfile and Gemfile.lock
COPY Gemfile* /srv/jekyll/

# Install bundler and dependencies
RUN gem install bundler && \
    bundle install --no-cache

EXPOSE 8080

# Copy the entry point script
COPY bin/entry_point.sh /tmp/entry_point.sh

# Set the entry point
CMD ["/tmp/entry_point.sh"]
