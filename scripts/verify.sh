#!/bin/bash

DATA_DIR="/app/data/"

if [ -z "$(find $DATA_DIR -name "*.sig" -type f 2>/dev/null)" ]; then
    echo "ERROR: No .sig files found in $DATA_DIR directory"
    exit 1
fi

find "$DATA_DIR" -type f -name "*.sig" | while read signing_file; do
    echo "signing file: $signing_file"
    original_file="$DATA_DIR$(basename "$signing_file" | sed 's/\.sig$//')"
    echo "original file $original_file"
    
    if [ ! -f "$original_file" ]; then
        echo "ERROR: Original file not found: $(basename "$original_file"). Skipping verification for: $(basename "$signing_file")"
        continue
    fi

    if openssl smime -verify \
        -engine gost \
        -inform DER \
        -in "$signing_file" \
        -content "$original_file" \
        -noverify > /dev/null 2>&1; #-noverify : skip certificate validation, check signature only
    then
        echo "Verification successful"
    else
        echo "Verification failure"
    fi
done