Introduction
=======

This is the docker image that provide the configured nginx and uwsgi combined features. This is usually used for deployed the Django features.

The image configured the features as below:
- Installed the Nginx;
- Installed the Python3;
- Installed the uwsgi;
- uwsgi bound on unix:/run/uwsgi.sock;
- uwsgi bound on 0.0.0.0:8080 (for testing purpose);
- nginx bound on 0.0.0.0:80;
- nginx upstream connected with uwsgi at unix:/run/uwsgi.sock;

The Dockerfile and related resources can be found on: [GitHub - https://github.com/kensonman/nginx-uwsgi](https://github.com/kensonman/nginx-uwsgi).


Usage
======
Execute the container with below commands:

    docker pull kensonman/nginx-uwsgi:latest
    docker run -u 0 -it kensonman/nginx-uwsgi:latest bash
        #Install the python library that you need
        # e.g.: pip install -r requirements.txt
        # e.g.: pip install django django-methodoverride
    docker run --rm -d -p 80:80 \
        -v <webapps-dir>:/usr/share/nginx/html:rw \
        -v <project-dir>:/usr/share/nginx/html/conf:ro \
        -v <static-dir>:/usr/share/nginx/html/static:ro \
        -v <media-dir>:/usr/share/nginx/html/media:rw \
        -it kensonman/nginx-uwsgi /startup
