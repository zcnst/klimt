# Ruby version will be passed using a build argument
FROM ruby:3.4.3-slim

# Set working directory
WORKDIR /app

ENV app_env=production

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install application dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copy application code first
COPY . /app

# Make the entrypoint script executable
RUN chmod +x /app/scripts/app-entrypoint.sh

# Expose port
EXPOSE 4567

# Set the entrypoint
ENTRYPOINT ["/app/scripts/app-entrypoint.sh"]

# Start the server
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]