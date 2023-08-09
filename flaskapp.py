from flask import Flask, request, jsonify, make_response
import logging_config
import json
import subprocess

# Segment of the URL used to validate the token from DockerHub webhook
try:
    with open('application_conf.json', 'r') as file:
        configuration = json.load(file)
        dockerhub_token = configuration.get('url_token')
except Exception as e:
    logging_config.logger_module1.error(f"Unable to load configuration from "
                                       f"./appplication_conf.json: {e}")

app = Flask(__name__)

@app.route(f"/{dockerhub_token}", methods=["POST"])
def webhook_handler():

    logging_config.logger_module1.info('Received a webhook request from Docker')

    # Extract JSON payload from the request
    json_data = request.json

    try:
        # Access specific values from the JSON data
        repo_name = json_data.get('repository').get('repo_name')
    except Exception as e:
        logging_config.logger_module1.error(f'Invalid JSON data in DockerHub POST payload: {e}')
        return jsonify({'error': 'Invalid JSON data'}), 400

    # Refer to: https://docs.docker.com/docker-hub/webhooks/
    logging_config.logger_module1.debug(f"Repository name: {repo_name}")

    # Open the scripts binder
    with open('scripts_binder.json') as file:
        # Parse the JSON content into a dictionary
        data_dict = json.load(file)
        # Execute scripts defined in the scripts binder
        scripts_list = data_dict.get(repo_name)
        if scripts_list:
            for script in scripts_list:
                logging_config.logger_module1.info(f'Executing script: {script}')
                path = f'scripts/{script}'
                result = subprocess.run(['/bin/bash', path], check=False)
                logging_config.logger_module1.debug(f'Script {script} completed with exit code {result.returncode}')
        else:
            logging_config.logger_module1.error(f'No configured scripts found in /scripts for repository: {repo_name}')

    response = make_response('', 204)
    return response
