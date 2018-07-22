#!/bin/bash -xe
source ./config.cfg
tar -xvf $archivesqfs -C "tmp/root" --exclude install
