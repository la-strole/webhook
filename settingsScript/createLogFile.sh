#!/bin/bash
touch /home/zhenya/webhook/webhook.log
# MAKE SHURE TO DO IT. 
# Because Flask app run by gunicorn.service from webhook user, 
#it can not write in your direcory. And It raises Error.
chmod a=rw /home/zhenya/webhook/webhook.log
