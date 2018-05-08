#!/bin/bash 

docker rm -f outpacing-photos-2018 || true

docker run -it \
	-v `pwd`:/srv \
	-v /home/trutch/Dropbox/Design/2018-outpacing-photos:/photos \
	--name='outpacing-photos-2018' \
	--net=host \
        outpacingmelanoma/photos:latest
