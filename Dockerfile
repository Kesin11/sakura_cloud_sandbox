FROM renovate/renovate
WORKDIR /usr/src/app/

# Workaround for renovatebot/renovate/issues/4016
# These code are for installing and using `global` bundler that using `bundle lock --update` inside renovate.
USER root
RUN apt-get update && apt-get install -y ruby ruby-bundler
RUN gem update --system
RUN gem install bundler
USER ubuntu

# Copy self-hosting config file.
COPY config.js ./config.js

ENTRYPOINT ["node", "/usr/src/app/dist/renovate.js"]
CMD []

# USAGE:
# docker run -e=RENOVATE_TOKEN=${YOUR_GITHUB_TOKEN} $DOCKER_IMAGE_NAME
# If you want to use renovate cache, add option -v "abs/path/to/host/dir:/tmp"

# for debug:
# docker run -it --entrypoint=bash $DOCKER_IMAGE_NAME