import subprocess
import time

from logging_config import logger_module2 as logger

# Emulator for test
"""
class SubprocessEmulator():
    def __init__(self) -> None:
        self.stderr = ''
"""
def image_manipulation(imagename, options, commands):

    # Stop container
    stop_command = ['sudo', 'docker', 'stop', f'{imagename.split("/")[1]}']
    
    stop_result = subprocess.run(stop_command,
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE,
                                 text=True)
    
    #  stop_result = SubprocessEmulator()
    if not stop_result.stderr:
        logger.info(f"Container {imagename} stopped.")
        # Remove image
        # wait for 5 seconds
        time.sleep(7)
        remove_image_command = ['sudo',
                                'docker', 'image', 'rm', f'{imagename}']
        #  remove_image_result = SubprocessEmulator()
        remove_image_result = subprocess.run(remove_image_command,
                                             stdout=subprocess.PIPE,
                                             stderr=subprocess.PIPE,
                                             text=True
                                            )
        if not remove_image_result.stderr:
            logger.info(f"Image {imagename} removed.")
        else:
            logger.error(f"Failed to remove image {imagename}:"
                         f"{remove_image_result.stderr}")
    else:
        logger.error(f"Failed to stop container: {stop_result.stderr}")

    # Pull new image from dockerhub and run container
    pull_image_command = ['sudo', 'docker', 'image', 'pull', imagename]
    #  pull_image_result = SubprocessEmulator()
    pull_image_result = subprocess.run(pull_image_command,
                                       stdout=subprocess.PIPE,
                                       stderr=subprocess.PIPE,
                                       text=True
                                      )
    if not pull_image_result.stderr:
        logger.info(f'Successfully pull image {imagename} from dockerhub')

        # Try to start pulled image
        default_options = {'-d': '',   # detach mode
                           '--name': imagename.split('/')[1],  # container name
                           '--rm': '',  # remove after stopping
                           '-q': ''  # quiet mode
                           }
        option_list = []
        for item in options.items():
            if item[0] in default_options:
                default_options.pop(item[0])
            option_list.extend([props for props in item if props != ''])
        for item in default_options.items():
            option_list.extend([props for props in item if props != ''])
        run_contaiter_command = ['sudo', 'docker', 'run']
        run_contaiter_command.extend(option_list)
        run_contaiter_command.append(imagename)
        run_contaiter_command.extend(commands)
        #  run_container_result = SubprocessEmulator()
        run_container_result = subprocess.run(run_contaiter_command,
                                              stdout=subprocess.PIPE,
                                              stderr=subprocess.PIPE,
                                              text=True)
        if not run_container_result.stderr:
            logger.info(f'Successfully run conatiner from image {imagename}')
        else:
            logger.error(f"Failed to run container from image {imagename}: "
                         f"{run_container_result.stderr}")

        return 0

    else:
        logger.error(f'Failed pull image {imagename} from dockerhub:'
                     f'{pull_image_result.stderr}')
        return -1
