# Create a Jekyll container from a Ruby Alpine image

# At a minimum, use Ruby 2.5 or later
FROM ruby:3.0-bullseye

# Add Jekyll dependencies to Alpine
RUN apt update

WORKDIR /site

# Update the Ruby bundler and install Jekyll

#RUN gem install bundler:2.4.19 
RUN gem install jekyll:4.3.2 jekyll-feed:0.17.0 jekyll-sitemap:1.4.0

EXPOSE 4000

CMD ["jekyll", "serve", "--livereload", "--host", "0.0.0.0"]