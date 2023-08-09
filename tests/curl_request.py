import subprocess
import json

# Generate a simulated POST request from DockerHub.
body = {"callback_url": "https://registry.hub.docker.com/u/svendowideit/testhook/hook/2141b5bi5i5b02bec211i4eeih0242eg11000a/",
        "push_data": {
            "pushed_at": 1417566161,
            "pusher": "trustedbuilder",
            "tag": "latest"
        },
        "repository": {
            "comment_count": 0,
            "date_created": 1417494799,
            "description": "",
            "dockerfile": "#\n# BUILD\u0009\u0009docker build -t svendowideit/apt-cacher .\n# RUN\u0009\u0009docker run -d -p 3142:3142 -name apt-cacher-run apt-cacher\n#\n# and then you can run containers with:\n# \u0009\u0009docker run -t -i -rm -e http_proxy http://192.168.1.2:3142/ debian bash\n#\nFROM\u0009\u0009ubuntu\n\n\nVOLUME\u0009\u0009[/var/cache/apt-cacher-ng]\nRUN\u0009\u0009apt-get update ; apt-get install -yq apt-cacher-ng\n\nEXPOSE \u0009\u00093142\nCMD\u0009\u0009chmod 777 /var/cache/apt-cacher-ng ; /etc/init.d/apt-cacher-ng start ; tail -f /var/log/apt-cacher-ng/*\n",
            "full_description": "Docker Hub based automated build from a GitHub repo",
            "is_official": False,
            "is_private": True,
            "is_trusted": True,
            "name": "testhook",
            "namespace": "svendowideit",
            "owner": "svendowideit",
            "repo_name": "johndou/testRepo",
            "repo_url": "https://registry.hub.docker.com/u/svendowideit/testhook/",
            "star_count": 0,
            "status": "Active"
        }
        }

body_json_string = json.dumps(body)
url = "http://127.0.0.1:5000/0f3078d2-ac61-47ec-8186-f422e19f4fb5"
command = ['curl', '-X', 'POST', '-H', 'Content-Type: application/json', '-d', body_json_string, url]
subprocess.run(command)