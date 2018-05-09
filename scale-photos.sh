#!/bin/bash 

SOURCE_VOLUME=/Users/trutch/Dropbox/Design/2018-outpacing-photos
docker rm -f outpacing-photos-2018 || true

docker run -it \
	-v `pwd`:/srv \
	-v $SOURCE_VOLUME:/photos \
	--name='outpacing-photos-2018' \
        outpacingmelanoma/photos:latest \
        rake -T
