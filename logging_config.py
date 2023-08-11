import logging

# Create a custom formatter
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )

# Create a handler for console output
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)
console_handler.setFormatter(formatter)

# Create a handler for file output
file_handler = logging.FileHandler('webhook.log')
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(formatter)

# Create loggers for your modules
logger_flask_app = logging.getLogger('webhookHandler')
logger_flask_app.setLevel(logging.DEBUG)
logger_flask_app.addHandler(console_handler)  # Send logs to console
logger_flask_app.addHandler(file_handler)     # Send logs to file
