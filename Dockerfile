FROM ubuntu:14.04


RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl git

# Compiling Ruby

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxslt-dev libxml2 libxml2-dev libpq-dev libmysqlclient-dev libyaml-dev libsqlite3-dev

RUN curl -L -o ruby.tar.gz http://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p547.tar.gz
RUN tar xzf ruby.tar.gz
RUN bash -lc "cd ruby* && ./configure"
RUN bash -lc "cd ruby* && make"
RUN bash -lc "cd ruby* && make install"

# Installing Ruby Gems

RUN curl -L -o rubygems.tar.gz http://production.cf.rubygems.org/rubygems/rubygems-2.4.1.tgz
RUN tar xzf rubygems.tar.gz
RUN bash -lc "cd rubygems* && ruby setup.rb"

# Installing BOSH

RUN gem install bosh_cli bosh_cli_plugin_micro --no-ri --no-rdoc

# Installing Python
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python python-yaml


CMD ["bash","-lc","cp -ra /bosh-environment /bosh-local && cd /bosh-local && bosh -n target $BOSH_TARGET && bosh login $BOSH_USERNAME $BOSH_PASSWORD && tests/bosh-test.py tests/$BOSH_TEST"]
