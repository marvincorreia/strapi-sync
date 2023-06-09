# Strapi Sync
This project shows how to configure `CICD` of a `strapi` project, these configurations ensure updates from time to time in order to guarantee that the `cms` data generated is up to date with the repository and enable developers to interact with the application installed on a remote server through changes in the repository.

## Pre-requisites
- Docker
- Ansible *(optional, only if you want to automate this tasks)*


## Installation
- [Manual method](#manual)
- [Automated method with ansible](#ansible)

## <a id="manual">Manual Method</a>
## Configure docker-compose file

The full compose file:

```yml
version: '3.7'

services: 
  strapi:
    image: node:18.15.0
    ports: 
      - 1337:1337
    volumes:
      - ./:/app
    working_dir: /app
    command: /bin/bash -c "yarn && yarn develop"
    environment:
      - NODE_ENV=development
    restart: unless-stopped
```
Copy the compose file to the root of your strapi app


Change the host port configuration if necessary:
```yaml
ports: 
  - <HOST_PORT>:1337
```
Change the package manager do you prefer:
```yaml
# yarn
command: /bin/bash -c "yarn && yarn develop"
#npm
command:  /bin/bash -c "npm install && npm run develop"

```

Running the compose file:

```shell
docker-compose -f docker-compose.dev.yml up -d
```

The strapi will be available on the port especified, by default on 1337

## Configure the script to synchronize the changes

This script is responsible for synchronizing the repository and the strapi app:

```bash
#!/bin/bash
BRANCH="main" #change this if necessary
git checkout $BRANCH
git add .
DATE=$(date '+%Y-%m-%d %H:%M:%S')
git commit -m "Updates at $DATE"
git pull origin $BRANCH
git push origin $BRANCH
```

Copy the script file to strapi folder and make it executable:

```
chmod +x strapi-sync.sh
```

## Configure cronjob to sync with the repository from time to time

Open crontab config file using the following command:

```shell
crontab -e
```

Append this line to the file:

```
*/5 * * * * /fullpath/to/strapi-sync.sh
```
*Remember to replace the path to the `stapi-sync.sh` location*

This cron will check for update at every 5th minute.

## Configure the machine ssh key to access the repository

If the server don't already have one, generate the keypair:
```
ssh-keygen
```
Copy the public key generated to your user access ssh-keys on your Git repository management platform,
to access the repository without password:
```
cat ~/.ssh/id_rsa.pub
```

## Ensure that the origin url is ssh instead https
```
git remote -v
```
If the url is not ssh type, go to the repository and copy the ssh url and configure it as bellow:
```
git remote set-url origin <SSH_URL>
```

## <a id="ansible">Ansible</a>
If you want to automate some of this tasks with Ansible follow this steps:

*Ensure to configure the docker-compose and the strapi-sync.sh file provided on the manual configuration*

Configure the ansible hosts file [here](./ansible/hosts):
```
myserver ansible_host=<server_ip> ansible_user=myuser ansible_ssh_port=22
```
Change the following script to your environment [here](./ansible/run-playbook.sh):
```bash
#!/bin/bash
STRAPI_PATH="/home/admin/strapiapp/" # change me (ensure the slash at the end of the path)
REPO_SSH_URL="git@<git_managment>:<repository>.git" # change me
HOST="myserver" # the same on the ansible host file

ansible-playbook playbook.yml -e strapi_path="$STRAPI_PATH" -e repo_ssh_url="$REPO_SSH_URL" -e hosts="$HOST"

# Copy the id_rsa.pub result to configure on your account access keys
```
Make the file executable:
```shell
sudo chmod +x ./ansible/run-playbook.sh
```
Run the playbook:

Is important to run the script inside the ansible directory to detect the [ansible.cfg](./ansible/ansible.cfg) file
```shell
cd ansible && ./run-playbook.sh
```
