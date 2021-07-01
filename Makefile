.DEFAULT_GOAL := deploy

APP_NAME = django-todo
APP_VERSION = 2.4.0

common-requirements:
	git version > /dev/null 2>&1
	docker version > /dev/null 2>&1

check-requirements: common-requirements
	kubectl version > /dev/null 2>&1
	helm version | grep -q "v3."

prepare:
	rm -rf gtd
	git clone https://github.com/shacker/gtd
	cp local.py gtd/project/
	cp Dockerfile .dockerignore gtd/

build: prepare
	docker build -t $(APP_NAME):$(APP_VERSION) gtd

deploy-db: build
	helm dependency update .helm
	helm upgrade --install $(APP_NAME) .helm \
		--namespace default \
		-f .helm/values.yaml \
		-f .helm/stages/local/secrets.yaml \
		--set-string go-app.image.repository=$(APP_NAME) \
		--set-string go-app.image.tag=$(APP_VERSION) \
		--wait \
		--set go-app.enabled=false

deploy-app:
	helm upgrade --install $(APP_NAME) .helm \
		--namespace default \
		-f .helm/values.yaml \
		-f .helm/stages/local/secrets.yaml \
		--set-string go-app.image.repository=$(APP_NAME) \
		--set-string go-app.image.tag=$(APP_VERSION) \
		--wait --timeout 300s

deploy: deploy-db deploy-app
	bash -c 'while ! curl -s http://localhost:8000 > /dev/null 2>&1; do sleep 1; done; open http://localhost:8000' &
	kubectl port-forward svc/$(APP_NAME) 8000:8000

clean:
	@helm uninstall $(APP_NAME) || true
	@kubectl delete job -l app.kubernetes.io/instance=$(APP_NAME) || true
	@kubectl delete pvc -l app.kubernetes.io/instance=$(APP_NAME) || true

compose-requirements: common-requirements

compose-up: prepare
	bash -c 'while ! curl -s http://localhost:8000 > /dev/null 2>&1; do sleep 1; done; open http://localhost:8000' &
	docker-compose up --build

compose-clean:
	docker-compose rm -vsf
