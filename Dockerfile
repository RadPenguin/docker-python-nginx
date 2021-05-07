FROM python:latest

ARG BUILD_DATE
ARG VERSION
LABEL build_version="RadPenguin version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV TZ="America/Edmonton"
ENV FLASK_ENV="production"

WORKDIR /app

# Install nginx.
RUN apt update && \
  apt install -yqq nginx

RUN echo '\n\
server {\n\
    listen 80 default_server;\n\
    listen [::]:80 default_server;\n\
    server_name _;\
\n\
    location / {\n\
        include uwsgi_params;\n\
        uwsgi_pass unix:/app/app.sock;\n\
    }\n\
}' > /etc/nginx/sites-enabled/default

RUN rm -f /var/log/nginx/* && \
  ln -sf /dev/stdout /var/log/nginx/access.log && \
  ln -sf /dev/stderr /var/log/nginx/error.log

# Install Node and NPM.
RUN mkdir -p /usr/local/bin/node && \
  cd /usr/local/bin/node && \
  curl --silent https://nodejs.org/dist/v14.16.1/node-v14.16.1-linux-x64.tar.xz | tar Jx --strip-components=1
RUN echo "export PATH=\$PATH:/usr/local/bin/node/bin" >> /etc/bash.bashrc

# Clean up
RUN apt-get clean && rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

# Add the app user.
RUN useradd app && \
  mkdir /home/app && \
  chown -R app:app \
    /home/app \
    /app

ADD ./init.sh /init.sh
CMD /init.sh
