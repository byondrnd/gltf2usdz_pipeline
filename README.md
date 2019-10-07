# gltf2usdz_pipeline
$ docker build -t gltf2usd .

$ docker run -v ${pwd}\\shared:/var/task/shared/ -dit --name gltf2usd gltf2usd:latest /bin/bash

$ docker exec -it gltf2usd /bin/bash

$ python gltf2usd/Source/gltf2usd.py -g /var/task/shared/input.gltf  -o /var/task/shared/output.usdc
$ usdzip /var/task/shared/ex.usdz --arkitAsset /var/task/shared/output.usdc