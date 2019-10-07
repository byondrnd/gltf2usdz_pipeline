# gltf2usdz_pipeline
$ docker build -t gltf2usd .

$ docker run -v ./shared:/var/task/shared/ -dit --name gltf2usd gltf2usd:latest /bin/bash

$ docker exec -it gltf2usd /bin/bash