import json
# Generate uuid token as part of url hook in dockerhub
import uuid


def rewrite_configuration(configuration):
    with open('application_conf.json', 'w') as file:
        try:
            json.dump(configuration, file, indent=4)
            print('Successfully rewritten configuration')
        except Exception as e:
            print(f'Failed to rewrite configuration: {e}')


token = uuid.uuid4()

# return to CLI
print(f"Your url to set on dockerhub as webhook:\n"
      f"<domain_name_to_handle_webhook>/token\ngenerated token:\n{token}")

# Configure ./application_conf.json
with open('application_conf.json', 'r') as file:
    # If configuration is already existed
    try:

        configuration = json.load(file)
        url_token = configuration.get('url_token')
        if url_token:
            rewrite_solution = input(
                f"There are already token configuration settings:\n"
                f"url token = {url_token}\n"
                f"Do you want to rewrite it? [y/n]?"
                )
            if rewrite_solution in ['y', 'Y']:
                configuration['url_token'] = str(token)
                rewrite_configuration(configuration)
            else:
                print("Ok, don't rewrite configuration")
        else:
            configuration['url_token'] = str(token)
            rewrite_configuration(configuration)

    except json.JSONDecodeError as e:
        print(f"Error loading configuration from "
              f"file ./application_conf.json: {e}")
