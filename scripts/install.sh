#!/usr/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ansible-playbook $DIR/../playbooks/homework.yaml

