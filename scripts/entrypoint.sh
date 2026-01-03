#!/bin/bash

case "$1" in
    signing)
        echo "Starting signing process..."
        exec "/app/scripts/signing.sh"
        ;;
    encrypt)
        echo "Starting encryption process..."
        exec "/app/scripts/encrypt.sh"
        ;;
    decrypt)
        echo "Starting decryption process..."
        exec "/app/scripts/decrypt.sh"
        ;;
    help)
        cat << EOF

Available commands:
  signing     - Sign all files in /app/data/ (excluding .enc and .sig files)
  encrypt     - Encrypt all files in /app/data/ (excluding .enc files)
  decrypt     - Decrypt all .enc files in /app/data/
  help        - Show this help message

Required volumes:
  -v /path/to/keys:/app/keys:ro
  -v /path/to/data:/app/data

Key files expected in /app/keys/:
  - cert.pem
  - private.key

Example:
  docker run -v /path/to/keys:/app/keys:ro \\
             -v /path/to/data:/app/data \\
             --rm openssl-gost signing
EOF
        ;;
    *)
        echo "Unknown command: $1"
        echo "Available commands: signing, encrypt, decrypt, help"
        exit 1
        ;;
esac