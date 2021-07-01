## About
It's a live demo of the django-todo application [https://github.com/shacker/django-todo]

According to the installation section I chose a way to start it with an already prepared django project https://github.com/shacker/gtd


## How to run
And you have two ways how to run it locally: via docker-compose or via kubernetes.

To run the application locally, we need to install the following common dependencies:
- git: https://git-scm.com/download/mac
- docker: https://docs.docker.com/docker-for-mac/install/

## The docker-compose way:
- Verify requirements: make compose-requirements
- Just run a command: make compose-up

After that, the browser window with the application should have opened.

To stop & remove containers run: make compose-clean

## The kubernetes way assumes slightly more steps:
- Enable built-in Kubernetes in docker for mac: https://docs.docker.com/docker-for-mac/install/
- Install Helm: https://helm.sh/docs/intro/install/
- Install kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
- Switch context on the right: kubectl config use-context docker-desktop
- Verify requirements: make check-requirements
- Run this command: make deploy

After that, the browser window with the application should have opened.

To cleanup the stage just run: make clean

In this example I utilize my own helm chart called go-app and bitnami chart for postgresql.

## P.S.
I had to change the project/local.example.py file a bit to be able to configure the application via environment variables.
For simplicity, I did not use any secret protection technics such as sops to encrypt the values in the .helm/stages/local/secrets.yaml file.
And please, you should also take into account that this is a demo project and this ways can not be used for a production environment!
