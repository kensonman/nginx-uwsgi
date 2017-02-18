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


