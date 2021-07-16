#!bin/bash

kubectl delete 'deployment.apps/glebchart'
kubectl delete 'service/glebchart'
helm uninstall 'glebchart'
helm install glebchart glebapp/
