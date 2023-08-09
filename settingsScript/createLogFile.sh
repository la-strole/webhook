#!/bin/bash
touch /home/zhenya/webhook/webhook.log
# PLEASE ENSURE TO COMPLETE THIS STEP.
# This is crucial because the Flask app is executed by the gunicorn.service under the webhook user.
# It doesn't have permissions to write in your directory, which can lead to errors.
chmod a=rw /home/zhenya/webhook/webhook.log
