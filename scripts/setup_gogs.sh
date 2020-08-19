#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
oc new-project $GUID-gogs --display-name="Gogs"
oc apply -f deploy/crds/gpte.opentlc.com_gogs_crd.yaml
oc apply -f deploy/crds/gpte.opentlc.com_v1alpha1_gogs_cr.yaml
oc apply -f ./deploy/service_account.yaml
oc apply -f ./deploy/role.yaml
oc apply -f ./deploy/role_binding.yaml
oc apply -f ./deploy/operator.yaml
oc apply -f ./deploy/gogs.yaml
sleep 60
oc patch deployment postgresql-gogs-gogs --patch='{ "spec": { "template": { "spec": { "securityContext": { "fsGroup": 2000 }}}}}'

