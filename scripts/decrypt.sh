#!/bin/bash

KEY_FILE="/app/keys/private.key"
DATA_DIR="/app/data/"

if [ ! -f "$KEY_FILE" ]; then
    echo "ERROR: Private key $KEY_FILE not found"
    exit 1
fi

if [ -z "$(find $DATA_DIR -name "*.enc" -type f 2>/dev/null)" ]; then
    echo "ERROR: No .enc files found in $DATA_DIR directory"
    exit 1
fi

find "$DATA_DIR" -type f -name "*.enc" | while read input_file; do
    echo "input file: $input_file"
    output_file="$DATA_DIR$(basename "$input_file" | sed 's/\.enc$//')"
    echo "output file $output_file"

    openssl smime -decrypt \
    -engine gost \
    -gost89 \
    -binary \
    -noattr \
    -inform DER \
    -in "$input_file" \
    -out "$output_file" \
    -inkey "$KEY_FILE"
done