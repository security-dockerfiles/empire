### About

Docker for the [Empire post-exploitation framework](https://github.com/EmpireProject/Empire/tree/master) based on Alpine Linux image.

It runs framework as a non-root user.

### Usage

Run Empire exposing ports 80 and 443 to host and mounting `/empire/downloads` to host `/home/$USER/mydir`:

```
docker run -it -p 80:80 -p 443:443 -v /home/$USER/mydir:/empire/downloads ilyaglow/empire
```


Or you can build it on your own:

```
git clone https://github.com/ilyaglow/docker-empire
cd docker-empire
docker build -t my-empire .
```
