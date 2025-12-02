#!/bin/bash
set -eux

DOMAIN_NAME="helloworld.com"

# Update and install packages
yum update -y
amazon-linux-extras install -y nginx1
yum install -y docker python3 git

# Start docker
service docker start
usermod -a -G docker ec2-user

# Create Dockerfile for namaste container
cat > /home/ec2-user/Dockerfile <<'EOF'
FROM nginx:alpine
RUN rm /usr/share/nginx/html/* || true
RUN echo "Namaste from Container" > /usr/share/nginx/html/index.html
EXPOSE 80
EOF

cd /home/ec2-user
docker build -t namaste:latest .

# Run container binding internal port 8080 -> container 80
docker run -d --name namaste -p 8080:80 namaste:latest

# Create NGINX configs
mkdir -p /etc/nginx/conf.d
cat > /etc/nginx/conf.d/ec2_instance.conf <<'EOF'
server {
    listen 80;
    server_name ec2-instance.helloworld.com;

    location / {
        return 200 'Hello from Instance';
        add_header Content-Type text/plain;
    }
}

server {
    listen 80;
    server_name ec2-docker.helloworld.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

systemctl enable nginx
systemctl restart nginx

# Install certbot (may require EPEL or snap; adjust per distro)
yum install -y certbot python3-certbot-nginx || true

# Note: To obtain certificates using certbot, DNS records for the domain must point to the instance Elastic IP.
# You can then run certbot --nginx -d ec2-instance.DOMAIN_NAME -d ec2-docker.DOMAIN_NAME manually or automate via Terraform/ACM.
