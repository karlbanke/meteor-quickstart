# Meteor Quickstart - Base Docker Image for Meteor Apps

### Build

Add the following to a `Dockerfile` in the root of your app:

```Dockerfile
FROM kbanke/meteor-quickstart:latest
```

If you want to run on Meteor 2.0 with MongoDB 4.2.8, pick this instead:

```Dockerfile
FROM kbanke/meteor-quickstart:meteor-2-0
```

Then you can build the image with:

```sh
docker build -t yourname/app .
```
### Ackknowledgement

This container and its source code is based on Jeremy Shimko's [meteor-launchpad](https://github.com/jshimko/meteor-launchpad). 
It's goal is to provide a base container that enables somewhat faster and better controlled builds by pre installing
the required software into the base container. It also runs Unit Tests by executing meteor test during
building the container. 

### Meteor Version

Currently this container preinstalls Meteor 1.6. 

There is a separate Dockerfile that preinstalls Meteor 2.6 alongside Mongo 4.2.8, see above.

### Run

Now you can run your container with the following command...
(note that the app listens on port 3000 because it is run by a non-root user for [security reasons](https://github.com/nodejs/docker-node/issues/1) and [non-root users can't run processes on port 80](http://stackoverflow.com/questions/16573668/best-practices-when-running-node-js-with-port-80-ubuntu-linode))

```sh
docker run -d \
  -e ROOT_URL=http://example.com \
  -e MONGO_URL=mongodb://url \
  -e MONGO_OPLOG_URL=mongodb://oplog_url \
  -e MAIL_URL=smtp://mail_url.com \
  -p 80:3000 \
  yourname/app
```

#### Delay startup

If you need to force a delay in the startup of the Node process (for example, to wait for a database to be ready), you can set the `STARTUP_DELAY` environment variable to any number of seconds.  For example, to delay starting the app by 10 seconds, you would do this:

```sh
docker run -d \
  -e ROOT_URL=http://example.com \
  -e MONGO_URL=mongodb://url \
  -e STARTUP_DELAY=10 \
  -p 80:3000 \
  yourname/app
```

### Build Options

Here are examples of both methods of setting custom options for your build:

**Option #1 - launchpad.conf**

To use any of them, create a `launchpad.conf` in the root of your app and add any of the following values.

```sh
# launchpad.conf

# Use apt-get to install any additional dependencies
# that you need before your building/running your app
# (default: undefined)
APT_GET_INSTALL="curl git wget"

# Install a custom Node version (default: latest 8.x)
NODE_VERSION=8.9.0

# Installs the latest version of each (default: all false)
```

**Option #2 - Docker Build Args**

If you prefer not to have a config file in your project, your other option is to use the Docker `--build-arg` flag.  When you build your image, you can set any of the same values above as a build arg.

```sh
docker build \
  --build-arg APT_GET_INSTALL="curl git wget" \
  --build-arg NODE_VERSION=8.9.0 \
  -t myorg/myapp:latest .
```

## License

MIT License

Copyright (c) 2017 Karl Banke

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
