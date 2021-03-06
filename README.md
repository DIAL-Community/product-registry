# DIAL Catalog of Digital Solutions

The Catalog of Digital Solutions is an interactive online resource to support donors, 
governments, and procurers in the development and implementation of digital strategies.​
The catalog aggregates data from a variety of sources (including the Digital Public 
Goods Alliance, WHO, Digital Square and the DIAL Open Source Center) and allows the 
user to identify and evaluate digital tools that may be applicable for their use cases
or projects. 

The catalog supports the [SDG Digital Investment Framework](https://digitalimpactalliance.org/research/sdg-digital-investment-framework/) developed by DIAL and ITU.

## Documentation

Complete documentation is available (including detailed installation and configuration
instructions) at 
[https://docs.osc.dial.community/projects/product-registry/en/latest/](https://docs.osc.dial.community/projects/product-registry/en/latest/ "DIAL Online Catalog Documentation")

## Prerequisites

 * Ruby (version 2.5 or greater)
 * Rails (version 5)
 * PostgreSQL 

## Application configuration

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