# Docker Production API Stack

## Description

This project sets up a production-ready API environment using Docker Compose. It includes a MongoDB replica set, backend API service, Certbot for SSL certificates, Nginx for reverse proxy, and Elasticsearch for search capabilities.


## Included Services

- **MongoDB Replica Set:** Three MongoDB instances set up as a replica set for high availability and data durability.
- **Backend API Service:** A service running your backend application in a Docker container. Replace the Dockerfile and application source code with your own.

- **Certbot:** Automatically handles SSL certificate generation and renewal for your domain.

- **Nginx:** Serves as a reverse proxy, routing incoming requests to the appropriate services.

- **Elasticsearch:** A powerful, real-time search and analytics engine.


## Getting Started

Ensure Docker and Docker Compose are installed on your machine.

1. Clone the repository.

```bash
$ git clone https://github.com/fsiatama/docker-mongo-nginx-api.git
$ cd docker-mongo-nginx-api
```

2. Replace the `backend-api` directory with your own backend application.

3. Update the `.env.example` file with your own environment variables and rename it to `.env`.

4. Build and run the Docker Compose file:

```bash
docker-compose up --build -d
```

## Configuration

The services' configurations are located in the docker-compose.yml file. If you need to change the default settings of a service, such as the exposed port or the environment variables, you can do so by editing this file.

The Nginx configuration is located in web-config/000-default.conf. If you want to change the server settings, you can do so by editing this file.

For SSL certificate generation, the Certbot service requires a domain name. Certbot stores the SSL certificates in the certbot/conf/ directory.

# SSL Certificate Generation and Renewal

This system uses Certbot to manage SSL certificates. The steps to generate, update, expand and renew a certificate are described below.

Before proceeding, ensure you replace `your-domain.com` with your actual domain name.

## Generate a new SSL certificate

To generate a new SSL certificate, run the following command:

```bash
sudo docker-compose run --rm certbot certonly --webroot --webroot-path=/var/www/certbot/ --dry-run -d your-domain.com
```

This command will perform a dry run. If everything is ok, proceed to generate the certificate by running:
```bash
sudo docker-compose run --rm certbot certonly --webroot --webroot-path=/var/www/certbot/ -d your-domain.com
```

## Update or expand an existing certificate

To update or expand an existing certificate to include another domain, use the following command:

```bash
sudo docker-compose --rm certbot certonly --webroot --webroot-path=/var/www/certbot/ --cert-name your-existing-domain.com -d your-new-domain.com
```

In this command, replace y`our-existing-domain.com` with the domain of your existing certificate and `your-new-domain.com` with the new domain you want to add to the certificate.

## Renew certificate

Certificates issued by Certbot are valid for 90 days. You can renew your certificates manually using the following command:

```bash
sudo docker-compose run --rm certbot renew
```
This command will renew all the certificates that are due for renewal.

# Nginx Configuration

The Nginx configuration is located in the `web-config/000-default.conf` file.

Currently, the configuration is set up to serve your application over HTTP and reverse proxy API requests to your `loan-management-api` service.

Once you have generated an SSL certificate for your domain using Certbot, you can enable serving your application over HTTPS. To do so, you'll need to uncomment (remove the `#` before) the second `server` block in the `000-default.conf` file.

This second `server` block includes configuration for listening on port 443 (the default port for HTTPS) and using the SSL certificate files generated by Certbot.

Here is how you can do it:

- Replace your-new-domain.com with your domain in both the server_name and ssl_certificate/ssl_certificate_key paths.

- Uncomment the lines by removing the `#` at the start of each line in the second `server` block.

Remember to save the file and restart Nginx for the changes to take effect. You can do this by rebuilding your Docker containers:

```bash
docker-compose down
docker-compose up --build -d
```

This will make your application accessible over HTTPS, providing better security for your users.

# Contributions

Contributions are welcome! Please submit a pull request or open an issue to make this project better for everyone.


For any additional information or queries, feel free to open an issue.


**Disclaimer:** This project comes with no warranty. Always review code for yourself and test thoroughly before using in a production environment.