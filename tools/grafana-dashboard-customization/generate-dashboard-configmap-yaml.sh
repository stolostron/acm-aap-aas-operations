#!/usr/bin/env bash
# Copyright (c) 2021 Red Hat, Inc.
# Copyright Contributors to the Open Cluster Management project

dashboard_name_file_path='./tools/grafana-dashboard-customization/dashboard-name.txt'
obs_namespace='open-cluster-management-observability'
raw_dashboard_name=$(cat $dashboard_name_file_path)

if command -v python &> /dev/null
then
    PYTHON_CMD="python"
elif command -v python2 &> /dev/null
then
    PYTHON_CMD="python2"
elif command -v python3 &> /dev/null
then
    PYTHON_CMD="python3"
else
    echo "Failed to found python command, please install firstly"
    exit 1
fi

start() {
  savePath="./cluster-bootstrap/multicluster-observability/base/dashboard"
  org_dashboard_name=$raw_dashboard_name
  dashboard_name=`echo ${raw_dashboard_name//[!(a-z\A-Z\0-9\-\.)]/-} | tr '[:upper:]' '[:lower:]'`

  podName=`kubectl get pods -n "$obs_namespace" -l app=multicluster-observability-grafana-dev --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'`
  if [ $? -ne 0 ] || [ -z "$podName" ]; then
      echo "Failed to get grafana pod name, please check your grafana-dev deployment"
      exit 1
  fi

  curlCMD="kubectl exec -it -n "$obs_namespace" $podName -c grafana-dashboard-loader -- /usr/bin/curl"
  XForwardedUser="WHAT_YOU_ARE_DOING_IS_VOIDING_SUPPORT_0000000000000000000000000000000000000000000000000000000000000000"
  dashboards=`$curlCMD -s -X GET -H "Content-Type: application/json" -H "X-Forwarded-User: $XForwardedUser" 127.0.0.1:3001/api/search`
  if [ $? -ne 0 ]; then
      echo "Failed to search dashboards, please check your grafana-dev instance"
      exit 1
  fi

  dashboard=`echo $dashboards | $PYTHON_CMD -c "import sys, json;[sys.stdout.write(json.dumps(dash)) for dash in json.load(sys.stdin) if dash['title'] == '$org_dashboard_name']"`

  dashboardUID=`echo $dashboard | $PYTHON_CMD -c "import sys, json; print(json.load(sys.stdin)['uid'])" 2>/dev/null`
  dashboardFolderId=`echo $dashboard | $PYTHON_CMD -c "import sys, json; print(json.load(sys.stdin)['folderId'])" 2>/dev/null`
  dashboardFolderTitle=`echo $dashboard | $PYTHON_CMD -c "import sys, json; print(json.load(sys.stdin)['folderTitle'])" 2>/dev/null`
  
  dashboardJson=`$curlCMD -s -X GET -H "Content-Type: application/json" -H "X-Forwarded-User:$XForwardedUser" 127.0.0.1:3001/api/dashboards/uid/$dashboardUID | $PYTHON_CMD -c "import sys, json; print(json.dumps(json.load(sys.stdin)['dashboard']))" 2>/dev/null`
  if [ $? -ne 0 ]; then
      echo "Failed to fetch dashboard json data, please check your dashboard name <$org_dashboard_name>"
      exit 1
  fi

  # delete dashboard uid avoid conflict with old dashboard
  dashboardJson=`echo $dashboardJson | $PYTHON_CMD -c "import sys, json; d=json.load(sys.stdin);del d['uid'];print(json.dumps(d))"`

  if [ $dashboardFolderId -ne 0 ]; then
  cat > $savePath/$dashboard_name.yaml <<EOF
kind: ConfigMap
apiVersion: v1
metadata:
  name: $dashboard_name
  namespace: open-cluster-management-observability
  annotations:
    observability.open-cluster-management.io/dashboard-folder: $dashboardFolderTitle
  labels:
    grafana-custom-dashboard: "true"
data:
  $dashboard_name.json: |
    $dashboardJson
EOF
  else
  cat > $savePath/$dashboard_name.yaml <<EOF
kind: ConfigMap
apiVersion: v1
metadata:
  name: $dashboard_name
  namespace: open-cluster-management-observability
  labels:
    grafana-custom-dashboard: "true"
data:
  $dashboard_name.json: |
    $dashboardJson
EOF
  fi
  # revert the content of dashboard name file
  echo "Delete me and input your dashboard name here" > $dashboard_name_file_path

  echo "Save dashboard <$dashboard_name> to $savePath/$dashboard_name.yaml"
}

start "$@"
