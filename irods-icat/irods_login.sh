#!/bin/bash

echo $1 | iinit

if [ $? -ne 0 ]; then
    echo "iinit failed"
fi
