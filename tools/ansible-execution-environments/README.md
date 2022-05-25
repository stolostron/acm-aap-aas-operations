# ansible-execution-environments


```bash
cd azure_ee_supported_1.11.0
ansible-builder build -f execution-environment.yml
cd context
docker build -t quay.io/cdoan_rh/azure_ee_supported:1.11.0 .
```

