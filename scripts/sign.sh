#!/bin/bash

CERT_FILE="/app/keys/cert.pem"
KEY_FILE="/app/keys/private.key"
DATA_DIR="/app/data/"

if [ ! -f "$CERT_FILE" ]; then
    echo "ERROR: Certificate $CERT_FILE not found"
    exit 1
fi

if [ ! -f "$KEY_FILE" ]; then
    echo "ERROR: Private key $KEY_FILE not found"
    exit 1
fi

if [ -z "$(find $DATA_DIR -type f ! -name '*.enc' ! -name '*.sig' 2>/dev/null)" ]; then
    echo "ERROR: No matching files found in $DATA_DIR directory"
    exit 1
fi

find "$DATA_DIR" -type f ! -name '*.enc' ! -name '*.sig' | while read input_file; do
    echo "input file: $input_file"
    output_file="$DATA_DIR$(basename "$input_file").sig"
    echo "output file $output_file"

    openssl smime -sign \
    -signer "$CERT_FILE" \
    -inkey "$KEY_FILE" \
    -engine gost \
    -binary \
    -noattr \
    -outform DER \
    -in "$input_file" \
    -out "$output_file"
done