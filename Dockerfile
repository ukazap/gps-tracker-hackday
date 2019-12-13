FROM ukazap/ruby:dev-bionic-2.6.3 AS dev
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt install -y tmux nodejs && npm install -g yarn && \
    /usr/bin/rbenv exec gem install foreman
WORKDIR /app
EXPOSE 3000
EXPOSE 3035
ENV WEBPACKER_DEV_SERVER_HOST=0.0.0.0
CMD /bin/bash

##########################

FROM dev AS builder
COPY . /app
ENV RAILS_ENV=production
RUN /usr/bin/rbenv exec bundle install --path=vendor/cache --without development test && \
    /usr/bin/rbenv exec bundle package && \
    /usr/bin/rbenv exec bundle exec rails assets:precompile

##########################

FROM ukazap/ruby:prod-bionic-2.6.3
WORKDIR /app
COPY --from=builder /app .
EXPOSE 3000
ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1 \
    PORT=3000
CMD /usr/bin/rbenv exec bundle exec puma -C config/puma.rb
