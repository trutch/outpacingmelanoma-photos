#!/bin/bash 

docker run -it \
	-v `pwd`:/srv \
	-v /home/rutschman/Dropbox/2018-outpacing-photos:/photos \
	--name='outpacing-photos-2018' \
	--net=host \
	outpacingmelanoma/photos:latest \
	scale['2018']
