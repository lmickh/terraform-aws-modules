apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${standard_dev_role_arn}
      username: standard-developer
      groups:
        - system:masters
    - rolearn: ${standard_ops_role_arn}
      username: standard-operations
      groups:
        - system:masters
