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

if [[ "$2" == true ]] ; then
  printf 'Generating a secret that conatins proxy URL for Alert Manager config usage in private cluster...\n'
  HTTP_PROXY_URL=$(kubectl get proxy -o=jsonpath='{.items[0].spec.httpProxy}')

  if [ -z "$HTTP_PROXY_URL" ]; then
    printf 'Error: Can not find http proxy configed in current private cluster\n'
    exit 1
  fi

  echo $HTTP_PROXY_URL > ./url.txt
  kubectl create secret generic proxy-url -n openshift-gitops --from-file=URL=./url.txt
  rm -f ./url.txt
  printf 'Secret generat successful!\n'
fi

printf 'Generating a secret that conatins acm & alert manager URL for Alert Manager config usage later...\n'
generate_url_secret
printf 'Secret generat successful!\n'

printf "=====================Create Alert manager config Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/alert-manager-config

printf "Alert Manager configuration created!"
