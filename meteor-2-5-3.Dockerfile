FROM public.ecr.aws/debian/debian:bullseye-slim
MAINTAINER Karl Banke <banke@mecom.de>

RUN groupadd -r node && useradd -m -g node node

ENV GOSU_VERSION=1.10 \
    MONGO_VERSION=5.0.27 \
    MONGO_MAJOR=5.0 \
    MONGO_PACKAGE="mongodb-org" \
    APP_SOURCE_DIR="/opt/meteor/src" \
    APP_BUNDLE_DIR="/opt/meteor/dist" \
    BUILD_SCRIPTS_DIR="/opt/build_scripts"

# Add entrypoint and build scripts
COPY scripts $BUILD_SCRIPTS_DIR
RUN chmod -R 750 $BUILD_SCRIPTS_DIR

# Define all --build-arg options
ARG APT_GET_INSTALL
ENV APT_GET_INSTALL $APT_GET_INSTALL

ARG NODE_VERSION
ENV NODE_VERSION ${NODE_VERSION:-14.18.2}

ARG INSTALL_MONGO
ENV INSTALL_MONGO $INSTALL_MONGO

# Node flags for the Meteor build tool
ARG TOOL_NODE_FLAGS
ENV TOOL_NODE_FLAGS $TOOL_NODE_FLAGS

ARG METEOR_VERSION
ENV METEOR_VERSION ${METEOR_VERSION:-2.5.3}

ONBUILD ARG NPM_TOKEN
ONBUILD ENV NPM_TOKEN $NPM_TOKEN

# optionally custom apt dependencies at app build time
RUN if [ "$APT_GET_INSTALL" ]; then apt-get update && apt-get install -y $APT_GET_INSTALL; fi

# install all dependencies, build app, clean up
RUN mkdir -p $APP_SOURCE_DIR && \
    cd $APP_SOURCE_DIR && \
       $BUILD_SCRIPTS_DIR/bullseye-install-deps.sh && \
       $BUILD_SCRIPTS_DIR/install-node.sh && \
       $BUILD_SCRIPTS_DIR/bullseye-install-mongo.sh && \
       $BUILD_SCRIPTS_DIR/install-meteor.sh 

# copy the app to the container
ONBUILD COPY . $APP_SOURCE_DIR

# build the app and clean up
ONBUILD RUN cd $APP_SOURCE_DIR && \
       $BUILD_SCRIPTS_DIR/build-meteor.sh && \
       $BUILD_SCRIPTS_DIR/post-build-cleanup.sh

# Default values for Meteor environment variables
ENV ROOT_URL="http://localhost" \
    MONGO_URL="mongodb://127.0.0.1:27017/meteor" \
    PORT=3000

EXPOSE 3000

WORKDIR $APP_BUNDLE_DIR/bundle

# start the app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["node", "main.js"]
