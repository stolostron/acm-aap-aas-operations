# SSO

This application will deploy the SSO based on the github idp. The organization `ACM-APP-SRE` created by our SRE shared robot account(acm-sre@redhat.com) will be leveraged to maintain the GitHub users who will allowed to log in.

Generate steps:
1. `acm-sre` send organization join invitation to your github account
2. After you accept the invitation, you can use your github account/password to login dev/prod env

Also this application maintains a group that bind with ClusterRoleBinding with cluster admin access. Notes: DevOps works here is need to update the user list in group manifest.
