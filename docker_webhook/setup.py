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
print(f"The URL you need to set up on DockerHub as a webhook:\n"
      f"\n<domain_name_to_handle_webhook>/token\n")

# Configure ./application_conf.json
with open('application_conf.json', 'r') as file:
    # If configuration already exists
    try:
        configuration = json.load(file)
        old_url_token = configuration.get('url_token')
        old_target_url = configuration.get('target_url')
        print(f'Your current configuration:\n'
              f'url_token: {old_url_token}\n'
              f'target_url: {old_target_url}\n')
        if old_url_token:
            solution = input('Do you want to change url_token? y/n: ')
            if solution in ['y', 'Y']:
                configuration['url_token'] = str(token)
                print("The URL token was successfully updated.")
            else:
                print("Alright, url_token remains unchanged")
        else:
            configuration['url_token'] = str(token)
            print(f"Because your URL token didn't exist, "
                  f"a new token was created with the value:\n{token}")
        if old_target_url:
            solution = input('Do you want to change target_url? y/n: ')
            if solution in ['y', 'Y']:
                configuration['target_url'] = input(
                    'Specify a new value for the target_url: ')
                print("The target_url was successfully updated.")
            else:
                print("Alright, target_url remains unchanged")
        else:
            solution = input('Do you want to set target_url? y/n: ')
            if solution in ['y', 'Y']:
                configuration['target_url'] = input(
                    'Specify a new value for the target_url: ')
                print("The target_url was successfully updated.")
            else:
                print("Alright, target_url remains unchanged")
        if (old_url_token != configuration.get('url_token') or 
            old_target_url != configuration.get('target_url')):
            rewrite_configuration(configuration)


    except json.JSONDecodeError as e:
        print(f"Error loading configuration from "
              f"./docker_webhook/application_conf.json file: {e}")
