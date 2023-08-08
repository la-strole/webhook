import logging

def configure_logging():
    logging.basicConfig(
        filename='webhook.log',
        level=logging.DEBUG,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
