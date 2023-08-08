#!/bin/bash
touch /home/zhenya/webhook/logfile.txt
# MAKE SHURE TO DO IT. 
# Because Flask app run by gunicorn.service from webhook user, 
#it can not write in your direcory. And It raises Error.
chmod a=rw /home/zhenya/webhook/logfile.txt

touch /home/zhenya/webhook/logfile_Flask.txt
chmod a=rw /home/zhenya/webhook/logfile_Flask.txt
