#!/usr/bin/env bash
set -e
ENV=$1
BRANCH=$2
SPEC=$3

commcare-cloud-bootstrap provision $SPEC --env $ENV
while
    commcare-cloud $ENV ping all --use-factory-auth
    [ $? = 4 ]
do :
done

commcare-cloud $ENV bootstrap-users --quiet --branch=$BRANCH


commcare-cloud $ENV ansible-playbook update_apt_cache.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_common.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_lvm.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_db.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_commcarehq.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_proxy.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_shared_dir.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_webworker.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_formplayer.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_mailrelay.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_formplayer.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_formplayer.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_formplayer.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_formplayer.yml --skip-check --quiet --branch=$BRANCH
commcare-cloud $ENV ansible-playbook deploy_formplayer.yml --skip-check --quiet --branch=$BRANCH


wait

- import_playbook: deploy_mailrelay.yml
- import_playbook: deploy_tmpreaper.yml
- import_playbook: deploy_etckeeper.yml
- import_playbook: deploy_airflow.yml
# migrate must happen before first fab, and also before touchforms can create its special user
commcare-cloud $ENV deploy-stack --skip-check --quiet -e 'CCHQ_IS_FRESH_INSTALL=1' --branch=$BRANCH --limit=couchdb2 &
- import_playbook: migrate_on_fresh_install.yml
- import_playbook: deploy_touchforms.yml
- import_playbook: deploy_http_proxy.yml

wait



commcare-cloud $ENV fab deploy:confirm=no --show=debug --set ignore_kafka_checkpoint_warning=true
