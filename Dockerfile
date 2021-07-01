FROM python:3.9-slim-buster

RUN pip install pipenv

WORKDIR /app

COPY Pipfile Pipfile.lock ./

RUN pipenv install --system --deploy --ignore-pipfile

COPY . .

CMD ["python", "manage.py", "runserver", "0:8000"]
