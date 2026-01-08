#!/bin/bash

DATA_DIR="/app/data"
KEYS_DIR="/app/keys"

case "$1" in
    sign|verify|encrypt|decrypt)
        echo "Starting $1 process..."
        exec "/app/scripts/$1.sh"
        ;;
    help)
        cat << EOF

Available commands:
  sign        - Sign all files in $DATA_DIR/ (excluding .enc and .sig files)
                Creates detached signatures with .sig extension
  verify      - Verify detached signatures (.sig files) in $DATA_DIR/
                Requires original files (without .sig extension)
  encrypt     - Encrypt all files in $DATA_DIR/ (excluding .enc files)
  decrypt     - Decrypt all .enc files in $DATA_DIR/
  help        - Show this help message

Required volumes:
  -v /path/to/keys:$KEYS_DIR:ro
  -v /path/to/data:$DATA_DIR

Key files expected in $KEYS_DIR/:
  - cert.pem
  - private.key

Example:
  docker run -v /path/to/keys:$KEYS_DIR:ro \\
             -v /path/to/data:$DATA_DIR \\
             --rm openssl-gost sign
EOF
        ;;
    *)
        echo "Unknown command: $1"
        echo "Available commands: sign, verify, encrypt, decrypt, help"
        exit 1
        ;;
esac