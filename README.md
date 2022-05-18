# ACM AAPaaS operations

This repository contains artifacts, OpenShift GitOps applications, policy, conrfiguration, dashboards, and more - all involved with operating the ACM hub management layer on top of the AAPaaS offering.

## How to deploying ACM Hub services on a new cluster

Please reference the doc [here](./cluster-bootstrap/README.md)

## Install pre-commit for repository secret detect in your local

1. Install `pre-commit` framework following the doc [here](https://pre-commit.com/#installation)
2. Install `detect-secrets` following the doc [here](https://github.com/Yelp/detect-secrets#installation)
3. Run `pre-commit install` to install the git hook scripts in your local `.git`

Now secret detect will run automatically on git commit! Detailed configuration and baseline defined in `.secrets.baseline` file.

**Notes**: If Detect secrets failed during your git commit like following: 
```
    Detect secrets...........................................................Failed
    - hook id: detect-secrets
    - exit code: 1

    ERROR: Potential secrets about to be committed to git repo!

    Secret Type: Secret Keyword
    Location:    fileName.yaml:10
```

Actions need to take:
* Check the specific location in the file as the error info indicated to double check if it is a real secret leak. 
* If not, run `detect-secrets scan --baseline .secrets.baseline` to update the baseline.
* Commit again with your all updates and `.secrets.baseline`  

