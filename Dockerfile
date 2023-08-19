FROM python:slim-bullseye


# Install docker, curl gnupg
# https://docs.docker.com/engine/install/debian/
RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN  echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce-cli 

# Copy working directory
COPY . /usr/app/
WORKDIR /usr/app

# Install poetry as python package manager
RUN curl -sSL https://install.python-poetry.org | python3 -

# Install project dependencies
RUN ~/.local/share/pypoetry/venv/bin/poetry install --without dev

# Run gunicorn
CMD ["/root/.local/share/pypoetry/venv/bin/poetry", "run", "gunicorn", "flaskapp:app", "-w", "2", "-b", "0.0.0.0:8000"]
