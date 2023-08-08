from flask import Flask, request, jsonify, render_template
import requests
from dockerHookHandler import image_manipulation
import datetime
import pytz
from logging_config import logger_module1 as logger


# Part of url to check if token came from dockerhub webhook
uuid_dokcerhub = 'c5c6229f-c846-48a0-b941-501e7c8d77ea'

app = Flask(__name__)


@app.route(f"/{uuid_dokcerhub}", methods=["POST"])  # type: ignore
def webhook_handler():
    logger.info('Get webhook request from docker')
    json_data = request.json

    if json_data is None:
        logger.error('Can not parse json data')
        return jsonify({'error': 'Invalid JSON data'}), 400

    # Access specific values from the JSON data
    # https://docs.docker.com/docker-hub/webhooks/
    callback_url = json_data.get('callback_url')
    repo_name = json_data.get('repository').get('repo_name')
    logger.debug(f"callback_url:{callback_url}, repo_name:{repo_name}")
    if repo_name == 'eugeneparkhom/pomodoro':
        options = {'-p': '8123:80'}
        commands = []
        result = image_manipulation(repo_name, options, commands)
    else:  # repo_name == 'eugeneparkhom/weatherbot':
        options = {'--env-file': 'path_to_env'}
        commands = ['make', '--file', '/home/Makefile', 'run']
        result = image_manipulation(repo_name, options, commands)

    response_headers = {'Content-Type': 'application/json'}
    # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    timestamp = datetime.datetime.now(pytz.utc)

    if result == 0:
        # response body https://docs.docker.com/docker-hub/webhooks/
        body = {
            "state": "success",
            "description": f"{repo_name} successfully installed "
                           f"at {timestamp.strftime('%H:%M %Z %d.%m.%Y')}",
            "context": "Continuous delivery of Docker",
            "target_url": f"https://webhook.dobryzhuk.com/{uuid_dokcerhub}"
            }
        requests.post(callback_url, json=body, headers=response_headers)
        logger.debug("Sent successful webhook POST request to dockerhub")
        return ('<p> accepted </p>')
    else:
        # response body https://docs.docker.com/docker-hub/webhooks/
        body = {
            "state": "failure",
            "description": f"{repo_name} failed installed at"
                           f"{timestamp.strftime('%H:%M %Z %d.%m.%Y')}."
                           f"{result}",
            "context": "Continuous delivery of Docker",
            "target_url": f"https://webhook.dobryzhuk.com/{uuid_dokcerhub}"
            }
        requests.post(callback_url, json=body, headers=response_headers)
        logger.debug("Sent failure webhook POST request to dockerhub")
        return ('<p>accepted</p>')


@app.route(f"/{uuid_dokcerhub}", methods=["GET"])
def webhook_handler_response():
    with open('webhook.log', 'r') as file:
        content = [line.strip() for line in file]

    return render_template('log_template.html', log_content=content)
