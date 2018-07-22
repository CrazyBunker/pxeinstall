#!/bin/bash
unsquashfs -d $1/root -f $2 
rm $2
