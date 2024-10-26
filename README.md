# Device Registry

This is a Ruby on Rails application that helps track devices assigned to users within an organization. It provides endpoints for user registration, authentication, and device assignment/unassignment.

## Requirements

- Ruby 3.2.3
- Rails 7.1.3
- SQLite3

## Setup

1. Clone the repository:
   ```
   git clone <repository-url>
   cd <project-directory>
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Set up the database:
   ```
   rails db:create
   rails db:migrate
   ```

4. Start the Rails server:
   ```
   rails server
   ```

The API will be available at `http://localhost:3000`.

## Configuration

### Database

This project uses SQLite3 by default. If you want to use a different database, update the `config/database.yml` file accordingly.

### Localization

The application supports multiple languages. Currently, English and Polish are available. To change the language, set the Accept-Language header in your API requests. For example:

- For English: Accept-Language: en
- For Polish: Accept-Language: pl

## API Endpoints

- `POST /api/v1/registration`: Create a new user account
- `POST /api/v1/session`: Log in a user
- `DELETE /api/v1/session`: Log out a user
- `POST /api/v1/devices/assign`: Assign a device to the current user
- `POST /api/v1/devices/unassign`: Unassign a device from the current user
- `GET /api/v1/devices`: Fetch all devices assigned to the current user
- `GET /api/v1/csrf`: Get a CSRF token for authentication

A complete Postman collection with all available endpoints has been included in the repository. To use this collection:

1. Install [Postman](https://www.postman.com/downloads/) if you haven't already.
2. Import the collection file from the repository into Postman.
3. Set up BASE_URL environment variable with a http://localhost:3000/api/v1 value.

## Authentication

This API uses session-based authentication. CSRF protection is enabled, and a CSRF token must be included in the headers of non-GET requests.

## Testing

RSpec is set up for testing. 

First, prepare the test database:
   ```
   rake db:test:prepare
   ```

Then you can run the test suite with:
   ```
   rspec spec
   ```
## Production

Application has a React frontend. Repository for it is available here: [frontend repository](https://github.com/lewkoowicz/device_registry_fe).

Both api and the frontend are deployed as docker containers on aws ec2 instance. You can either create new user or sign in with existing credentials:

- email: device@device
- password: device

The application is available under https://deviceregistry.pl