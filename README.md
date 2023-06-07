# Strapi auto update

## Configure docker-compose file

Change the host port configuration if it necessary:
```yaml
ports: 
   - <HOST_PORT>:1337
```
Change the package manager if necessary:
```yaml
# yarn
command: /bin/bash -c "yarn && yarn develop"
#npm
command:  /bin/bash -c "npm install && npm run develop"

```

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
This cron will check for update at every 5th minute.

## Configure the machine ssh key to access the repository

If the server don't already have one, generate the keypair
```
ssh-keygen
```
Copy the public key generated to the repository ssh keys configuration to allow access without password:
```
cat ~/.ssh/id_rsa.pub
```

# Ensure that the origin url is ssh instead https
```
git remote -v
```
If the url is not ssh type, go to the repository and copy the ssh url and configure it as bellow:
```
git remote set-url origin <SSH_URL>
```







