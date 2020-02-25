#!/bin/bash
set -e

cd /candidates
git pull

cd /products
git pull

cd /t4d
rake sync:unicef_goods['/candidates/nominees']
# rake sync:public_goods['/products/products']
rake sync:digi_square_digital_good
rake sync:osc_digital_good
rake sync:purge_removed_products['/candidates/nominees']
rake sync:update_version_data
rake sync:update_license_data
rake sync:update_statistics_data
rake sync:sync_digital_health_atlas_data
