web: bin/rails server -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -e production -q default -C config/sidekiq.yml

