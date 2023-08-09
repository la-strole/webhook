import json
import uuid


# Generate a UUID token for the DockerHub webhook URL
def rewrite_configuration(configuration):
    with open('application_conf.json', 'w') as file:
        try:
            json.dump(configuration, file, indent=4)
            print('Configuration successfully updated')
        except Exception as e:
            print(f'Failed to update configuration: {e}')


token = uuid.uuid4()

# Display URL for setting up DockerHub webhook
print(f"Your URL to configure on DockerHub as a webhook:\n"
      f"<domain_name_to_handle_webhook>/token\ngenerated token:\n{token}")

# Configure ./application_conf.json
with open('application_conf.json', 'r') as file:
    # If configuration already exists
    try:
        configuration = json.load(file)
        url_token = configuration.get('url_token')
        if url_token:
            rewrite_solution = input(
                f"Token configuration already exists:\n"
                f"url token = {url_token}\n"
                f"Do you want to update it? [y/n]?"
            )
            if rewrite_solution in ['y', 'Y']:
                configuration['url_token'] = str(token)
                rewrite_configuration(configuration)
            else:
                print("Alright, configuration remains unchanged")
        else:
            configuration['url_token'] = str(token)
            rewrite_configuration(configuration)

    except json.JSONDecodeError as e:
        print(f"Error loading configuration from "
              f"./application_conf.json file: {e}")
