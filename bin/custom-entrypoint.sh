#!/usr/bin/env bash

set -ex

python jbl_chat/manage.py migrate

exec "${@}"
