#!/bin/bash

USER = "user"
VENV = "/venv/"

sudo apt update
sudo apt install git python3-dev libffi-dev gcc libssl-dev libdbus-glib-1-dev

sudo apt install python3-venv
python3 -m venv $VENV
source $VENV/bin/activate
pip install -U pip

pip install git+https://opendev.org/openstack/kolla-ansible@master
sudo mkdir -p /etc/kolla
sudo chown $USER:$USER /etc/kolla
cp -r $VENV/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
cp $VENV/share/kolla-ansible/ansible/inventory/all-in-one .

kolla-ansible install-deps

kolla-ansible bootstrap-servers -i ./all-in-one
kolla-ansible prechecks -i ./all-in-one
kolla-ansible deploy -i ./all-in-one

pip install python-openstackclient -c https://releases.openstack.org/constraints/upper/master
kolla-ansible post-deploy