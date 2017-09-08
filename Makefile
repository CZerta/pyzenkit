#-------------------------------------------------------------------------------
# MASTER MAKEFILE FOR PYZENKIT PACKAGE
#
# This file is part of PyZenKit project (https://pypi.python.org/pypi/pyzenkit).
#
# Copyright (C) since 2015 CESNET, z.s.p.o (http://www.ces.net/)
# Copyright (C) since 2015 Jan Mach <honza.mach.ml@gmail.com>
# Use of this package is governed by the MIT license, see LICENSE file.
#
# This project was initially written for personal use of the original author.
# Later it was developed much further and used for project of author`s employer.
#-------------------------------------------------------------------------------

DIR_LIB = pyzenkit

DIST_SIZE:=$(shell ls dist | wc -l)

SPHINXOPTS      =
SPHINXBUILD     = sphinx-build
SPHINXPROJ      = PyZenKit
SPHINXSOURCEDIR = .
SPHINXBUILDDIR  = doc/_build

#
# Color code definitions for colored terminal output
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
#
RED    = \033[0;31m
GREEN  = \033[0;32m
ORANGE = \033[0;33m
BLUE   = \033[0;34m
PURPLE = \033[0;35m
CYAN   = \033[0;36m
NC     = \033[0m


#-------------------------------------------------------------------------------


#
# Default make target, alias for 'help', you must explicitly choose the target.
#
default: help

#
# Perform all reasonable tasks to do full build.
#
full: docs archive bdist deploy

#
# Perform local build.
#
build: archive bdist

#
# Perfom build from automated system.
#
buildbot: bdist

#
# Check the project code.
#
check: pyflakes pylint test


#-------------------------------------------------------------------------------


help:
	@echo ""
	@echo " ${GREEN}─────────────────────────────────────────────────${NC}"
	@echo " ${GREEN}              LIST OF MAKE TARGETS${NC}"
	@echo " ${GREEN}─────────────────────────────────────────────────${NC}"
	@echo ""
	@echo "  * ${GREEN}default${NC}: alias for help, you have to pick a target"
	@echo "  * ${GREEN}help${NC}: print this help and exit"
	@echo "  * ${GREEN}show-version${NC}: show current project version"
	@echo "  * ${GREEN}full${NC}: generate documentation, archive previous packages, build new distribution and deploy to PyPI"
	@echo "  * ${GREEN}build${NC}: archive previous packages and build new distribution"
	@echo "  * ${GREEN}buildbot${NC}: build new distribution using buildbot automated system"
	@echo "  * ${GREEN}deps${NC}: install various dependencies"
	@echo "     = ${ORANGE}deps-python${NC}: install Python dependencies with pip3"
	@echo "  * ${GREEN}docs${NC}: generate project documentation"
	@echo "     = ${ORANGE}docs-help${NC}: show list of all available html build targets"
	@echo "     = ${ORANGE}docs-html${NC}: generate project documentation in HTML format"
	@echo "  * ${GREEN}check${NC}: perform extensive code checking"
	@echo "     = ${ORANGE}pyflakes${NC}: check source code with pyflakes"
	@echo "        - pyflakes-lib: check library with pyflakes, exclude test files"
	@echo "        - pyflakes-test: check test files with pyflakes"
	@echo "     = ${ORANGE}pylint${NC}: check source code with pylint"
	@echo "        - pylint-lib: check library with pylint, exclude test files"
	@echo "        - pylint-test: check test files with pylint"
	@echo "     = ${ORANGE}test${NC}: run unit tests with nosetest"
	@echo "  * ${GREEN}archive${NC}: archive previous packages"
	@echo "  * ${GREEN}bdist${NC}:   build new distribution"
	@echo "  * ${GREEN}install${NC}: install distribution on local machine"
	@echo "  * ${GREEN}deploy${NC}:  deploy to PyPI"
	@echo ""
	@echo " ${GREEN}─────────────────────────────────────────────────${NC}"
	@echo ""


#-------------------------------------------------------------------------------


show-version: FORCE
	@PYTHONPATH=. python3 -c "import pyzenkit; print(pyzenkit.__version__);"


#-------------------------------------------------------------------------------


deps: deps-python

deps-python: FORCE
	@echo "\n${GREEN}*** Installing Python dependencies ***${NC}\n"
	@pip3 install -r requirements.pip --upgrade


#-------------------------------------------------------------------------------


docs: docs-html

docs-help: FORCE
	@$(SPHINXBUILD) -M help "$(SPHINXSOURCEDIR)" "$(SPHINXBUILDDIR)" $(SPHINXOPTS) $(O)

docs-html: FORCE
	@echo "\n${GREEN}*** Generating project documentation ***${NC}\n"
	@$(SPHINXBUILD) -M html "$(SPHINXSOURCEDIR)" "$(SPHINXBUILDDIR)" $(SPHINXOPTS) $(O)


#-------------------------------------------------------------------------------


pyflakes: pyflakes-lib pyflakes-test

pyflakes-lib: FORCE
	@echo "\n${GREEN}*** Checking code with pyflakes ***${NC}\n"
	-@python3 -m pyflakes $(DIR_LIB)/*.py

pyflakes-test: FORCE
	@echo "\n${GREEN}*** Checking test files with pyflakes ***${NC}\n"
	-@python3 -m pyflakes $(DIR_LIB)/tests/*.py

pylint: FORCE
	@echo "\n${GREEN}*** Checking test files with pylint - DISABLED ***${NC}\n"

pylint-lib: FORCE
	@echo "\n${GREEN}*** Checking code with pylint ***${NC}\n"
	-@python3 -m pylint $(DIR_LIB)/*.py --rcfile .pylintrc-lib

pylint-test: FORCE
	@echo "\n${GREEN}*** Checking test files with pylint ***${NC}\n"
	-@python3 -m pylint $(DIR_LIB)/tests/*.py --rcfile .pylintrc-test

test: FORCE
	@echo "\n${GREEN}*** Checking code with nosetests ***${NC}\n"
	@nosetests


#-------------------------------------------------------------------------------


archive: FORCE
	@if ! [ `ls dist/pyzenkit* | wc -l` = "0" ]; then\
		echo "\n${GREEN}*** Moving old distribution files to archive ***${NC}\n";\
		mv -f dist/pyzenkit* archive;\
	fi

bdist: FORCE
	@echo "\n${GREEN}*** Building Python packages ***${NC}\n"
	@python3 setup.py sdist bdist_wheel

install: FORCE
	@echo "\n${GREEN}*** Performing local installation ***${NC}\n"
	@pip3 install dist/pyzenkit*.whl --upgrade

deploy: FORCE
	@echo "\n${GREEN}*** Deploying packages to PyPI ***${NC}\n"
	@twine upload dist/* --skip-existing

# Empty rule as dependency will force make to always perform target
# Source: https://www.gnu.org/software/make/manual/html_node/Force-Targets.html
FORCE:
