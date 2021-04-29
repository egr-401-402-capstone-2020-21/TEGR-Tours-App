# Dockerfile Production version
FROM ruby:2.7.0

ENV RAILS_ROOT /var/www/TEGR-Tours-App
RUN mkdir -p $RAILS_ROOT/tmp/pids


RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y build-essential libpq-dev postgresql-client nodejs yarn

WORKDIR $RAILS_ROOT

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

COPY TEGR-Tours-App/ .
RUN rm -rf node_modules vendor
RUN gem install rails bundler
RUN bundle install
RUN yarn install
# RUN chown -R user:user /TEGR-Tours-App

#RUN exec bundle exec rake assets:precompile --trace
# VOLUME /app

EXPOSE 3000
CMD ./docker-entrypoint.sh
CMD ["rails", "server", "-b", "0.0.0.0"]

# CMD exec bundle exec unicorn -E production -c config/containers/unicorn.rb;
