FROM ruby:2.4.1-slim
LABEL maintainer "team@shiftcommerce.com"

# Install essentials and cURL
RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential curl git libpq-dev python unzip

# Install drafter for API Blueprint Parsing
RUN mkdir /tmp_build
RUN cd /tmp_build
RUN bash -c "git clone git://github.com/apiaryio/drafter.git; cd drafter; git checkout tags/v3.2.7; git submodule update --init --recursive; ./configure; make test; make drafter; make install"
RUN rm -rf /tmp_build

# Add repository and key for postgres
RUN echo deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main > /etc/apt/sources.list.d/pgdg.list
RUN curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Install pg_dump for schema dump
RUN apt-get update -qq && apt-get install -y --no-install-recommends postgresql-client-9.6

# Configure the main working directory
ENV app /app
RUN mkdir $app
WORKDIR $app

# Set the where to install gems
ENV GEM_HOME /rubygems
ENV BUNDLE_PATH /rubygems

# Link the whole application up
ADD . $app
