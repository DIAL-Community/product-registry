#!/bin/bash
set -e

cd /candidates
git pull

cd /products
git pull

cd /maturity-rubric
git pull

cd /t4d
rake sync:generate_repositories
rake sync:public_goods
rake sync:digi_square_digital_good
rake sync:osc_digital_good_local
rake sync:update_license_data
rake sync:update_statistics_data
rake sync:update_language_data
rake maturity_sync:sync_data['/maturity-rubric']
rake sync:fetch_website_data
