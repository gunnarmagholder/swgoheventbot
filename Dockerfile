# Use version 3.2 of ruby
FROM ruby:3.2

# create workdif in container
WORKDIR /usr/src/app

# install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the sourcefile(s)
COPY . .

# Expose port (dunno if we have to)
EXPOSE 3000

# start the bot
CMD ["ruby", "event_bot.rb"]