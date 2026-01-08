#!/bin/bash

CERT_FILE="/app/keys/cert.pem"
DATA_DIR="/app/data/"

if [ ! -f "$CERT_FILE" ]; then
    echo "ERROR: Certificate $CERT_FILE not found"
    exit 1
fi

if [ -z "$(find $DATA_DIR -type f ! -name '*.enc' 2>/dev/null)" ]; then
    echo "ERROR: No matching files found in $DATA_DIR directory"
    exit 1
fi

find "$DATA_DIR" -type f ! -name '*.enc' | while read input_file; do
    echo "input file: $input_file"
    output_file="$DATA_DIR$(basename "$input_file").enc"
    echo "output file $output_file"

    openssl smime -encrypt \
    -engine gost \
    -gost89 \
    -binary \
    -noattr \
    -outform DER \
    -in "$input_file" \
    -out "$output_file" \
    "$CERT_FILE"
done