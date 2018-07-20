#!/bin/bash
#NAME=`echo $1 | cut -d'.' -f1`
unsquashfs -d resources/root -f resources/image_v1.squashfs 
