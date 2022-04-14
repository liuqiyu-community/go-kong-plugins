# Setup to start Kong using a Go plugin

> Prerequisites:
> * Docker
> * Docker Compose

Follow these steps to start Kong using a Go plugin "hello" as an embedded server. The plugin source code comes from https://github.com/Kong/go-plugins and was slightly modified to run as an embedded server (as explained in https://docs.konghq.com/gateway-oss/2.3.x/external-plugins/#embedded-server).

* Build the Docker image containing Kong and the plugin
    ```sh
    make
    ```
* Go to the `test` folder and run the image:
    ```sh
    cd test
    docker-compose up
    ```
* Send a request through Kong
    ```sh
    curl -I http://localhost:8000
    ```
    We should see the response header added by the hello plugin: `x-hello-from-go: Go says Bonjour to localhost:8000`

There are two unexplained issues:

1. After starting the Docker container, we can see the following emergency logs from Kong:

    ```sh
    kong_1  | 2021/03/22 20:08:39 [notice] 32#0: *6 [kong] process.lua:239 Starting hello, context: ngx.timer
    kong_1  | 2021/03/22 20:08:39 [emerg] 32#0: lua pipe child close() socket 0.0.0.0:8000 failed (9: Bad file descriptor)
    kong_1  | 2021/03/22 20:08:39 [emerg] 32#0: lua pipe child close() socket 0.0.0.0:8000 failed (9: Bad file descriptor)
    kong_1  | 2021/03/22 20:08:39 [emerg] 32#0: lua pipe child close() socket 0.0.0.0:8000 failed (9: Bad file descriptor)
    kong_1  | 2021/03/22 20:08:39 [emerg] 32#0: lua pipe child close() socket 0.0.0.0:8443 failed (9: Bad file descriptor)
    kong_1  | 2021/03/22 20:08:39 [emerg] 32#0: lua pipe child close() socket 0.0.0.0:8443 failed (9: Bad file descriptor)
    kong_1  | 2021/03/22 20:08:39 [emerg] 32#0: lua pipe child close() socket 0.0.0.0:8443 failed (9: Bad file descriptor)
    ```

2. When trying to gracefully stop Kong (Ctrl-C in the shell where docker-compose was launched), it takes 10 seconds

If we deactivate the hello plugin in `kong.conf` and `kong.yml`, those two issues disappear.