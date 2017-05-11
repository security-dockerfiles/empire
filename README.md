### About

Docker for the [Empire 2.0](https://github.com/EmpireProject/Empire/tree/2.0_beta) based on Alpine Linux image.

It runs framework as a non-root user.

### Usage

Run Empire exposing ports 80 and 443 to host and mounting /empire/downloads to host `./mydir`:

```
docker run -it --rm -p 80:80 -p 443:443 -v ./mydir:/empire/downloads ilyaglow/empire-beta
```

Or you can build it on your own:

```
git clone https://github.com/ilyaglow/docker-empire-beta
cd docker-empire-beta
docker build -t my-empire .
```
