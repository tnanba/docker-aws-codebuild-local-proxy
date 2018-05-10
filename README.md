# docker-aws-codebuild-local-proxy

[amazon/aws-codebuild-local](https://hub.docker.com/r/amazon/aws-codebuild-local/) launches inner container from `docker-compose.yml'.
But proxy configuration does not inherit from outer container to inner.

This image add proxy configurations(`http_proxy`, `https_proxy`, `HTTP_PROXY`, `HTTPS_PROXY`) to `docker-compose.yml`.
