# Notification System

A scalable, efficient, and maintainable notification system that can send notifications to users via different channels (email, SMS, push notifications).

## Features

- Multiple notification channels (email, SMS, push)
- Multiple notification types (alert, reminder, promotional, system)
- User preferences for notification channels
- Asynchronous processing of notifications
- Rate limiting to prevent notification overload
- Notification status tracking
- Support for sending notifications to groups
- Detailed API documentation

## Tech Stack

- Ruby 3.4.2
- Ruby on Rails 8.0.2
- PostgreSQL (for database)
- Redis (for Sidekiq and rate limiting)
- Sidekiq (for background jobs)
- ActionMailer (for email notifications)
- Twilio (for SMS notifications)
- Firebase Cloud Messaging (for push notifications)
- Swagger (for API documentation)
- Docker (for containerization)

## Setup

### Installation

1. Clone the repository
```
git clone https://github.com/GreatWorldDev/notification-system.git
cd notification-system
```

2. Install dependencies
```
bundle install
```

3. Set up environment variables (copy .env.example to .env and update with specific values)
```
cp .env.example .env
```

4. Set up the database
```
rails db:create db:migrate db:seed
```

5. Start the application
```
rails server
```

6. Start Sidekiq to process background jobs
```
bundle exec sidekiq
```

### Docker Setup

Build and start the containers, automatically setting up the database (creation, migration, and seeding).
```
docker compose up --build -d
```

## API Documentation

The API documentation is available at `/api-docs` when the application is running.

## Architecture

### Components

- **Controllers**: Handle API requests and responses
- **Models**: Define data structures and relationships
- **Services**: Implement business logic for sending notifications
- **Jobs**: Handle asynchronous processing of notifications
- **Mailers**: Handle email notifications

### Key Design Decisions

- **Strategy Pattern**: Different notification channels are implemented as separate classes following the Strategy pattern, allowing for easy addition of new channels.
- **Asynchronous Processing**: Notifications are processed asynchronously using Sidekiq to handle high throughput.
- **Rate Limiting**: Implemented using Rack::Attack to prevent notification overload.
- **Scalability**: The system is designed to scale horizontally by adding more workers to process notifications.
