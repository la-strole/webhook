Prerequisites:

    1. Ensure you have Python, Nginx, and a Unix-based operating system installed.
    2. Create a Linux user with permissions to execute Docker commands (username: webhook). Use the visudo command to grant Docker execution rights.

Steps:

    3. Install required packages (Gunicorn, Flask, etc.) using Poetry: Run poetry install --without dev.
    4. Create a Unix socket for Gunicorn, assigning it to the user www-data (the default Nginx user on Linux).
    5. Establish a Gunicorn service for both the webhook user and Flask, utilizing the /run/gunicorn.sock path.
    6. Configure the Nginx server to act as a proxy, forwarding requests to the Gunicorn socket.
    7. Initiate the Gunicorn service.
    8. To enable logging, generate a webhook.log file in the Flask app directory, ensuring it has write permissions for others (since the webhook user will be writing to it).
    9. Set permissions for the webhook user to run scripts in the scripts directory.
