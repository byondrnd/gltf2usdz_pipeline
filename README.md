# gltf2usdz_pipeline
$ docker build . -t gltf2usd -m 8g

$ docker run -v shared:/usr/src/app/shared -dit --name gltf2usd gltf2usd:latest

$ docker exec -it gltf2usd /bin/bash