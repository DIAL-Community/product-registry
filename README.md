# DIAL Catalog of Digital Solutions

The Catalog of Digital Solutions is an interactive online resource to support donors, 
governments, and procurers in the development and implementation of digital strategies.​
The catalog aggregates data from a variety of sources (including the Digital Public 
Goods Alliance, WHO, Digital Square and the DIAL Open Source Center) and allows the 
user to identify and evaluate digital tools that may be applicable for their use cases
or projects. 

The catalog supports the [SDG Digital Investment Framework](https://digitalimpactalliance.org/research/sdg-digital-investment-framework/) developed by DIAL and ITU.

## Repositories

Note that this repository contains the code for the back-end/API for the Catalog. The front-end
code for the Catalog can be referenced at: 
https://gitlab.com/dial/osc/eng/t4d-online-catalog/catalog-front/-/tree/development(https://gitlab.com/dial/osc/eng/t4d-online-catalog/catalog-front/-/tree/development)

## Documentation

Complete documentation is available (including detailed installation and configuration
instructions) at 
[https://docs.osc.dial.community/projects/product-registry/en/latest/](https://docs.osc.dial.community/projects/product-registry/en/latest/ "DIAL Online Catalog Documentation")

Please also reference the [Wiki page for the Catalog](https://solutions-catalog.atlassian.net/wiki/spaces/SOLUTIONS/overview?homepageId=33072), which contains information about upcoming feature development, releases, and additional documentation.

## Prerequisites

 * Ruby (version 2.5 or greater). See [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/) for installation instructions.
 * Rails (version 5.2). Once Ruby is installed, can install Rails using the following command in a terminal:
 ```gem install rails```
 * PostgreSQL (version 12 or higher). See [Postgres Download](https://www.postgresql.org/download/) for download and install instructions.
 * Redis. See [Getting Started with Redis](https://redis.io/docs/getting-started/) for instruction. Please ensure that redis is set to start and run in the background automatically. This [link](https://redis.io/docs/getting-started/#installing-redis-more-properly) describes how to configure redis. 

## Postgres Configuration for development

Before running the application configuration for your local development environment, Postgres must be configured 
and a user created (the username must align with the DB username specified in the setEnv.sh file)

Use the username and password that you configured during Postgres installation to connect to postgres using the following
command: ```psql postgres```

Run the following commands in psql:
```
create user <username> with password '<password>';
alter user <username> with superuser;
```

## Application configuration for development

Environment variables must be set prior to running the application. See the setEnv.example.sh script 
in the root directory of the project and set all variables for development environment. In your 
terminal session, run the setEnv.sh script to set environment variables:

 * source ./setEnv.sh dev

Be sure to update your setEnv.sh with the correct database username and password that were configured 
in the step above.

Note: running this command will set the environment variables for the current terminal session only. 
If you open a new terminal window (or reboot), you will need to run this command again.

To configure and run the application, navigate to project directory and run the following commands:

 * bundle install (requires bundler 2)
 * rails db:create
 * rails db:migrate
 * rails db:seed
 * rails server

The application will run on localhost port 3000 by default.


## Using Docker Compose

 * docker-compose build
 * docker-compose up -d


## Backing up and restoring database

 * rails db:backup   (will store dump in db/backups directory)
 * rails db:restore

## Copyright Information

Copyright © 2021 Digital Impact Alliance. This program is free software: you can 
redistribute it and/or modify it under the terms of the GNU Affero General 
Public License as published by the Free Software Foundation, either version 3 
of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY 
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along 
with this program.  If not, see <https://www.gnu.org/licenses/>.