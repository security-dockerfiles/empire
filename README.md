[![](https://images.microbadger.com/badges/image/ilyaglow/empire.svg)](https://microbadger.com/images/ilyaglow/empire "Get your own image badge on microbadger.com")

### About

Docker for the [Empire post-exploitation framework](https://github.com/EmpireProject/Empire/tree/master) based on Alpine Linux image.

It runs framework as a non-root user.

### Usage

Run Empire exposing ports 80 and 443 to host and map `/empire/downloads` to host's `/home/$USER/mydir/downloads`:

```
docker run -it -p 80:80 -p 443:443 -v /home/$USER/mydir:/data ilyaglow/empire
```

### Containerize your current setup

You can specify the following environment variables:
* `EMPIRE_API_PASSWORD`
* `EMPIRE_API_PERMANENT_TOKEN`
* `EMPIRE_API_USERNAME`
* `EMPIRE_DB_LOCATION`
* `EMPIRE_IP_BLACKLIST`
* `EMPIRE_IP_WHITELIST`
* `EMPIRE_CHAIN_LOCATION`
* `EMPIRE_PKEY_LOCATION`

#### How to use an existing database

```
docker run -it -p 80:80 -p 443:443 -p 8080:8080 -v /your/path:/data -e EMPIRE_DB_LOCATION=/data/empire.db empire
```

