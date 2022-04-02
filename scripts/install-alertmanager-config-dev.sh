#!/bin/sh

generate_url_secret()
{
  while [[ $(kubectl get route -n open-cluster-management multicloud-console --no-headers --ignore-not-found | wc -l) -eq 0 ]]; do echo "Waiting for creating ACM route" && sleep 60; done

  while [[ $(kubectl get route -n open-cluster-management-observability alertmanager --no-headers --ignore-not-found | wc -l) -eq 0 ]]; do echo "waiting for creating Alertmanager route" && sleep 60; done

  ACM_CONSOLE_URL="$(kubectl get route -n open-cluster-management multicloud-console -o jsonpath="{.spec.host}")"

  ALERTMANAGER_URL="$(kubectl get route -n open-cluster-management-observability alertmanager -o jsonpath="{.spec.host}")"

  echo -n $ACM_CONSOLE_URL > ./acm_url.txt
  echo -n $ALERTMANAGER_URL > ./alertmanager_url.txt

  kubectl create secret generic console-url -n openshift-gitops --from-file=ACM_CONSOLE_URL=./acm_url.txt --from-file=ALERTMANAGER_URL=./alertmanager_url.txt

  rm -f ./acm_url.txt
  rm -f ./alertmanager_url.txt
}

printf 'Generating a secret that conatins acm & alert manager URL for Alert Manager config usage later...\n'
generate_url_secret
printf 'Secret generat successful!\n'

printf "=====================Create Alert manager config Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/alert-manager-config
printf "Alert Manager configuration created!"
