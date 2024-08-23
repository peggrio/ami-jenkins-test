#!/bin/bash
export DEBIAN_FRONTEND=noninteractive


sudo mv /tmp/jenkins.conf /etc/nginx/conf.d
# sudo ln -s /etc/nginx/conf.d/jenkins.conf /etc/nginx/sites-enabled/

sudo nginx -t

sudo systemctl restart nginx