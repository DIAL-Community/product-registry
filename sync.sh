#!/bin/bash
set -e

cd /candidates
git pull

cd /t4d
rake sync:public_goods['/candidates/candidates']
rake sync:digi_square_digital_good
rake sync:osc_digital_good
rake sync:update_version_data
rake sync:update_license_data
