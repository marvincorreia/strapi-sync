#!/bin/bash
STRAPI_PATH="/home/admin/strapiapp/" # change me (ensure the slash at the end of the path)
REPO_SSH_URL="git@<git_managment>:<repository>.git" # change me
HOST="myserver" # the same on the ansible host file

ansible-playbook playbook.yml -e strapi_path="$STRAPI_PATH" -e repo_ssh_url="$REPO_SSH_URL" -e hosts="$HOST"

# Copy the id_rsa.pub result to configure on your account access keys