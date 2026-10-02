## OpenSSL GOST Docker

OpenSSL Docker image with GOST algorithm support

### Installation

#### Option 1: Docker Hub

```bash
docker pull podvoyskiy/openssl-gost:latest
```

#### Option 2: Build from source

```bash
git clone https://github.com/podvoyskiy/openssl-gost
cd openssl-gost
docker build -t openssl-gost .
```

### Volume Mounts

`/app/keys` - Directory containing private key and certificate

`/app/data` - Directory for input/output files

### Available Commands

| Command | Description |
|-------------|-------------|
| `sign`   | Sign all files in `/app/data/` (excluding `.enc` and `.sig` files). Creates detached signatures with `.sig` extension |
| `verify` | Verify detached signatures (`.sig` files) in `/app/data/`. Requires original files (without `.sig` extension) |
| `encrypt` | Encrypt all files in `/app/data/` (excluding `.enc` files) |
| `decrypt` | Decrypt all `.enc` files in `/app/data/` |
| `help` | Show help message |

### Usage example

```bash
# Docker Hub
docker run -v /path/to/keys:/app/keys:ro \
           -v /path/to/data:/app/data \
           --rm podvoyskiy/openssl-gost:latest <command>

# From source
docker run -v /path/to/keys:/app/keys:ro \
           -v /path/to/data:/app/data \
           --rm openssl-gost <command>
```