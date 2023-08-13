from flask import Flask, request, jsonify, make_response
import logging_config
import json
import subprocess
import threading  # or `import multiprocessing` for processes

# Segment of the URL used to validate the token from DockerHub webhook
try:
    with open('application_conf.json', 'r') as file:
        configuration = json.load(file)
        dockerhub_token = configuration.get('url_token')
except Exception as e:
    logging_config.logger_flask_app.error(f"Unable to load configuration from "
                                          f"./appplication_conf.json: {e}")

app = Flask(__name__)


def background_scripts_execution(pwd, repo_name, tag_name, container_name):

    # Open the scripts binder
    with open('scripts_binder.json') as file:
        # Parse the JSON content into a dictionary
        data_dict = json.load(file)
        # Execute scripts defined in the scripts binder
        scripts_list = data_dict.get(repo_name)
        if scripts_list:
            for script in scripts_list:
                logging_config.logger_flask_app.info(
                    f'Executing script: {script}'
                    )
                path = f'{pwd}/scripts/{script}'
                result = subprocess.run(['/bin/bash', path,
                                         repo_name,
                                         tag_name,
                                         container_name
                                         ], check=False)
                logging_config.logger_flask_app.debug(
                    f'Script {script} completed '
                    f'with exit code {result.returncode}')
        else:
            logging_config.logger_flask_app.error(
                f'No configured scripts found '
                f'in /scripts for repository: {repo_name}')


@app.route(f"/{dockerhub_token}", methods=["POST"])
def webhook_handler():

    logging_config.logger_flask_app.info(
        'Received a webhook request from Docker')

    # Extract JSON payload from the request
    json_data = request.json

    try:
        # Access specific values from the JSON data
        repo_name = json_data.get('repository').get('repo_name')
        container_name = repo_name.split('/')[1]
        tag_name = json_data.get('push_data').get('tag')
    except Exception as e:
        logging_config.logger_flask_app.error(f'Invalid JSON data '
                                            f'in DockerHub POST payload: {e}')
        return jsonify({'error': 'Invalid JSON data'}), 400

    # Refer to: https://docs.docker.com/docker-hub/webhooks/
    logging_config.logger_flask_app.debug(f"Repository name: {repo_name}")

    # Run the 'pwd' command to get the current working directory
    process = subprocess.Popen(['pwd'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

    # Decode the bytes output to a string
    current_directory = stdout.decode('utf-8').strip()

    logging_config.logger_flask_app.debug(f"Current Directory: {current_directory}")

    # Start a new thread or process for the background task
    task_thread = threading.Thread(
        target=background_scripts_execution, 
        args=(current_directory, repo_name, tag_name, container_name)
        )
    task_thread.start()

    response = make_response('', 204)
    return response
