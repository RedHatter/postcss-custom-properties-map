PATH := $(PWD)/node_modules/.bin:$(PATH)

all: lint dist test


# ESnext compilation
# ======================

dist:
	rm -rf $@
	babel ./src -d $@

develop: dist
	babel-node $@


# Code quality
# ============

lint:
	eslint ./src ./test

test: lint
	ava

cover:
	nyc ava

cover-browse: cover
	opn ./coverage/lcov-report/index.html

coveralls: cover
	(cat ./coverage/lcov.info | coveralls) || exit 0


# Publish package to npm
# @see npm/npm#3059
# =======================

publish: all
	npm publish

# Release, publish
# ================

# "patch", "minor", "major", "prepatch",
# "preminor", "premajor", "prerelease"
VERS ?= "patch"
TAG  ?= "latest"

release: all
	npm version $(VERS) -m "Release %s"
	npm publish --tag $(TAG)
	git push --follow-tags


# Tools
# =====

rebuild:
	rm -rf node_modules
	npm install


.PHONY: dist develop test
.SILENT: dist develop cover
