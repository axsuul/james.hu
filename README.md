# james.hu

## Setup
Install Docker on Ubuntu. Uses the Dockerfile `dockerfile/ghost`. Clone repo into `/srv/james.hu`.

## Run
```
$ docker run -d -p 80:2368 -v /srv/james.hu:/ghost-override dockerfile/ghost
```
