# Localhost SSL Certificate Generator

This repository provides a lightweight and automated way to generate **self-signed SSL/TLS certificates** for localhost and custom subdomains, making it easy to enable HTTPS in local development environments.

## Features
- **Self-signed SSL certificates** for `localhost` and additional subdomains.
- **Multi-format support** (PEM, CRT, KEY) for web servers and applications.
- **Automated certificate generation** using a simple `Makefile`.
- **Multi-platform support** with Docker.
- **Signed and verified using Cosign** for security.

---

## Prerequisites
Ensure you have the following installed:
- **Docker** (if running in a containerized environment)
- **Make** (for automated certificate generation)

---

## Installation & Usage
### **1. Run the container**
To generate a localhost SSL certificate, use the following command:
```sh
  docker run --rm -v $(pwd)/localhost-ssl:/app incodig/localhost-cert-generator:latest
```
This will generate SSL certificates in the certs/ directory.

### **2. Install with Makefile (Manual Generation)**
If you are running locally with Makefile, follow these steps:

```sh
    cd localhost-ssl
    make generate-install
```
This will create the certificates and install them in your system's trust store (Linux/macOS).

### **3. Adding Custom Subdomains**
By default, the certificate includes localhost and www.localhost.

To add more subdomains:

Edit the configuration file: 
`certs/localhost.ext`
Add the desired subdomains under [alt_names]:
```editorconfig
[alt_names]
DNS.1 = localhost
DNS.2 = www.localhost
DNS.3 = dev.localhost
```
Re-generate and install the certificate:
```sh
    make generate-install
```

## Contributing
Pull requests and contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (git checkout -b feature-branch).
3. Commit your changes (git commit -m 'Add new feature').
4. Push to your branch (git push origin feature-branch).
5. Open a Pull Request.