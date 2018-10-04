VENV = $(PWD)/.env
PIP = $(VENV)/bin/pip
PYTHON = $(VENV)/bin/python
FLASK = $(VENV)/bin/flask
AFPY_SERVER = afpy_web

all: install serve

install:
	test -d $(VENV) || python3 -m venv $(VENV)
	$(PIP) install --upgrade --no-cache pip setuptools -e .[test]

clean:
	rm -fr dist
	rm -fr $(VENV)
	rm -fr *.egg-info

check-outdated:
	$(PIP) list --outdated --format=columns

test:
	$(PYTHON) -m pytest tests.py afpy.py --flake8 --isort --cov=afpy --cov=tests --cov-report=term-missing

serve:
	env FLASK_APP=afpy.py FLASK_ENV=development $(FLASK) run

afpy:
	ssh -t $(AFPY_SERVER) 'cd site && git pull'
	ssh -t $(AFPY_SERVER) 'killall uwsgi-3.6 && /usr/local/etc/rc.d/uwsgi restart'
