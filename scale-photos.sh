#!/bin/bash 

docker rm -f ooutpacing-photos-2018 || true

docker run -it \
	-v `pwd`:/srv \
	-v /home/trutch/Dropbox/Design/2018-outpacing-photos:/photos \
	--name='outpacing-photos-2018' \
	--net=host \
        outpacingmelanoma/photos:0.0.13
