#!/usr/bin/env bash
set -e
ENV=$1
BRANCH=$2
SPEC=$3




# Generate the key and secret
#cchq pvtest ansible-playbook deploy_riakcs.yml --branch=pv/riak --skip-check

cchq pvtest update-riak
#
## Encrypt the vault file
#echo 123 | ansible-vault encrypt vault.yml --vault-password-file=/bin/cat
#
## Define the key and secret to add
#KEY="$(ssh 18.208.153.165 "cat /home/ansible/riak_creds.txt" | grep "riak_key" | awk -F':' '{print $2}')"
#SECRET="$(ssh 18.208.153.165 "cat /home/ansible/riak_creds.txt" | grep "riak_secret" | awk -F':' '{print $2}')"
#
## Add the key and secret
#echo 123 | ansible-vault encrypt <( \
#  echo 123 | ansible-vault view vault.yml --vault-password-file=/bin/cat \
#    | python -c 'import yaml, sys;vars = yaml.load(sys.stdin); vars["secrets"]['"('$KEY')"'] = '"('$SECRET')"';print(yaml.safe_dump(vars, default_flow_style=False))'\
#) --output vault.yml --vault-password-file=/bin/cat
#
## Decrypt the vault file
#echo 123 | ansible-vault decrypt vault.yml --vault-password-file=/bin/cat
#
