FROM python:3
MAINTAINER Kenson Man <kenson@kenson.idv.hk>
ENV UID=1000
ENV GID=1000
ENV USERNAME=webmaster
ENV PASSWD=cs5FWjMFeXBmZEkTRMp86h2A
ENV WORKDIR=/usr/share/nginx/html
ENV DIR_MEDIA=media
ENV DIR_STATIC=static
ENV UWSGI_WORKERS=5
ENV DJANGO=">1.10"

RUN echo ">>> Installing the packages..." \
&& apt-get update \
&& apt-get install -y --fix-missing libpq-dev python-dev python3-dev vim libjpeg-dev python-dateutil gnupg uwsgi uwsgi-plugin-python3 python3-pip nginx sudo \
&& chmod 777 /run \
&& echo ">>> Creating the user<${USERNAME}::${UID}> and group<${GID}> for ftp..."  \
&& groupadd -g ${GID} ${USERNAME} \
&& useradd -u ${UID} -g ${GID} -M -d ${WORKDIR} ${USERNAME} \
&& echo "${USERNAME}:${PASSWD}" | chpasswd \
&& adduser ${USERNAME} www-data \
&& echo ">>> Configuring nginx..." \
&& setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/nginx \
&& echo "upstream uwsgi { server unix:/run/uwsgi.sock; }" > /etc/nginx/conf.d/upstream.conf \
&& echo "client_max_body_size 100M;" > /etc/nginx/conf.d/postsize.conf \
&& sed -i "59a\\\\tinclude /etc/nginx/sites-available/default.d/*.conf;" /etc/nginx/sites-available/default \
&& sed -i "37,41s/^/#/g" /etc/nginx/sites-available/default \
&& mkdir /etc/nginx/sites-available/default.d \
&& echo "location /media { alias ${WORKDIR}/${DIR_MEDIA}; }" >> /etc/nginx/sites-available/default.d/path.conf \
&& echo "location /static { alias ${WORKDIR}/${DIR_STATIC}; }" >> /etc/nginx/sites-available/default.d/path.conf \
&& echo "location / {\n     uwsgi_pass uwsgi;\n    include uwsgi_params;\n}" >> /etc/nginx/sites-available/default.d/path.conf \
&& chown -R ${USERNAME}:www-data /var/lib/nginx /var/log/nginx \
&& echo ">>> Configuring uwsgi..." \
&& pip install "django${DJANGO}" \
&& cp /usr/share/uwsgi/conf/default.ini /etc/uwsgi/apps-available/default.ini \
&& sed -i "s/^workers = [0-9]\+.*/workers = ${UWSGI_WORKERS}/g" /etc/uwsgi/apps-available/default.ini \
&& sed -i "s/^socket = .*/socket = \/run\/uwsgi.sock/g" /etc/uwsgi/apps-available/default.ini \
&& sed -i "s/^pidfile = .*/pidfile = \/run\/uwsgi.pid/g" /etc/uwsgi/apps-available/default.ini \
&& echo "http = 0.0.0.0:8080" >> /etc/uwsgi/apps-available/default.ini \
&& echo "pythonpath=/usr/local/lib/python3.6/site-packages" >> /etc/uwsgi/apps-available/default.ini \
&& echo "wsgi-file=/usr/share/nginx/html/conf/wsgi.py" >> /etc/uwsgi/apps-available/default.ini \
&& echo "chdir = /usr/share/nginx/html" >> /etc/uwsgi/apps-available/default.ini \
&& echo "vacuum=true" >> /etc/uwsgi/apps-available/default.ini \
&& echo "plugins=python3" >> /etc/uwsgi/apps-available/default.ini \
&& echo ">>> Generating the startup scripts..." \
&& echo "#!/bin/bash" > /startup \
&& echo "echo \"Container Homepage: https://github.com/kensonman/nginx-uwsgi\"" >> /startup \
&& echo "uwsgi --ini /etc/uwsgi/apps-available/default.ini &" >> /startup \
&& echo "/usr/sbin/nginx -g \"daemon off;\"" >> /startup \
&& chown ${USERNAME}:${USERNAME} /startup \
&& chmod +x /startup \
&& echo ">>> Finishing..."

ADD sample/. /usr/share/nginx/html/

WORKDIR ${WORKDIR}
USER ${USERNAME}
CMD /startup
