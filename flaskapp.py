from flask import Flask, request, jsonify
from logging_config import logger_module1 as logger
import json
import subprocess


# Part of url to check if token came from dockerhub webhook
uuid_dokcerhub = 'c5c6229f-c846-48a0-b941-501e7c8d77ea'

app = Flask(__name__)


@app.route(f"/{uuid_dokcerhub}", methods=["POST"])
def webhook_handler():

    logger.info('Get webhook request from docker')

    # Get JSON payload from request
    json_data = request.json

    try:
        # Access specific values from the JSON data
        repo_name = json_data.get('repository').get('repo_name')
    except Exception as e:
        logger.error(f'Invalid JSON data in dockerhub POST payload: {e}')
        return jsonify({'error': 'Invalid JSON data'}), 400

    # https://docs.docker.com/docker-hub/webhooks/
    logger.debug(f"repo_name:{repo_name}")

    # Open scripts binder
    with open('scripts_binder.json') as file:
        # Parse the JSON content into a dictionary
        data_dict = json.load(file)
        # Run scripts defined in scripts binder
        for script in data_dict.get(repo_name):
            logger.info(f'Run script {script}')
            path = f'/scripts/{script}'
            result = subprocess.run(['/bin/bash', path], check=False)
            logger.debug(f'Script {script} finished'
                         f'with code {result.returncode}'
                         )
