# T4D Product Registry

# Prerequisites

 * Ruby (version 2.3 or greater)
 * Rails (version 5)
 * PostgreSQL 

# Application configuration

To configure and run the application, navigate to project directory and run the following commands:

 * bundle install (requires bundler 2)
 * rails db:create
 * rails db:migrate
 * rails db:seed
 * rails server

The application will run on localhost port 3000 by default.


# Using Docker Compose

 * docker-compose build
 * docker-compose up -d


# Backing up and restoring database

 * rails db:backup   (will store dump in db/backups directory)
 * rails db:restore
