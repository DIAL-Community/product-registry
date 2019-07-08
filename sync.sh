#!/bin/bash
set -e

cd /candidates && git pull
cd /t4d && rake sync:public_goods['/candidates/candidates'] && rake sync:digi_square_digital_good
