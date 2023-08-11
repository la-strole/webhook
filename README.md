0. Pre-requisites: python, nginx, unix os, poetry(global)
0.1. Create linux user with permissions to run docker command (user: webhook, use visudo to let run docker command)
1. Install gunicorn, flask, etc from poetry: poetry install --without dev
2. Create unix socket for gunicorn (for user www-data - default nginx user on linux)
3. Create gunicorn service for gunicorn ( for user webhook and flask )
4. Configure nginx server to proxy requests to gunicorn socket
5. Start gunicorn service
6. For logging create webhook.log file in flask app directory with permissions to write to it others (because webhook user should write there)
7. Set user permissions to run scripts in directory scripts for webhook user