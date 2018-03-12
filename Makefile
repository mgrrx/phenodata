# Release this piece of software
# Synopsis:
#   make release bump=minor  (major,minor,patch)
release: bumpversion push sdist pypi-upload

docs-html: install-doctools
	$(eval venvpath := ".venv_project")
	touch doc/index.rst
	export SPHINXBUILD="`pwd`/$(venvpath)/bin/sphinx-build"; cd doc; make html


# Utility targets
bumpversion: install-releasetools
	$(eval venvpath := ".venv_project")
	@$(venvpath)/bin/bumpversion $(bump)

push:
	git push && git push --tags

sdist:
	$(eval venvpath := ".venv_project")
	@$(venvpath)/bin/python setup.py sdist

pypi-upload: install-releasetools
	$(eval venvpath := ".venv_project")
	@$(venvpath)/bin/twine upload --skip-existing dist/*.tar.gz

install-doctools:
	$(eval venvpath := ".venv_project")
	@test -e $(venvpath)/bin/python || `command -v virtualenv` --python=`command -v python` --no-site-packages $(venvpath)
	@$(venvpath)/bin/pip install --quiet --requirement requirements-docs.txt

install-releasetools:
	$(eval venvpath := ".venv_project")
	@test -e $(venvpath)/bin/python || `command -v virtualenv` --python=`command -v python` --no-site-packages $(venvpath)
	@$(venvpath)/bin/pip install --quiet --requirement requirements-release.txt
