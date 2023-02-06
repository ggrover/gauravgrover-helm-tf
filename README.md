# Deploy Helm Consul using Terraform

- [Deploy Helm Consul using Terraform](#deploy-helm-consul-using-terraform)
  - [Terraform deployment](#terraform-deployment)
  - [Setup](#setup)
    - [Kubernetes Client](#kubernetes-client)
    - [AWS Setup](#aws-setup)
    - [AWS Credentials](#aws-credentials)
  - [Install Terraform](#install-terraform)
    - [Terraform State files](#terraform-state-files)
  - [Deployment](#deployment)
  - [Destroy](#destroy)

The terraform script uses the helm provider to deploy helm consul to a cluster

## Terraform deployment

- Get the kubernetes context for deployment to cluster
- Sets the repository
- Set the Helm chart to deploy
- Set the namespace to deploy to - default in this case

## Setup

### Kubernetes Client

Follow the instructions outlined here <https://kubernetes.io/docs/tasks/tools/>

### AWS Setup

Take a look at the following documentation for more information: 

<https://github.com/ggrover/gauravgrover-docs#aws-setup-and-configuration>

### AWS Credentials

Take a look at the following documentation for more information: 

<https://github.com/ggrover/gauravgrover-docs#authentication>

Also take a look at this information:

See [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
for all the ways to provide AWS credentials.

## Install Terraform

Go through the following guide for installation: <https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>

### Terraform State files

The state files are sent to S3 via CDKTS's S3 Backend. It is set to the following bucket
`cdktf-backend-k8s` . It was created via the AWS console

- Authenticate with AWS by running the following script located: <https://github.com/ggrover/gauravgrover-k8s-cdktf-demo/blob/main/auth.sh> ` . ./auth.sh && sso aws-personal ` 

## Deployment

- Set the context
  - For minikube run `. ./auth.sh && mk ` 
  - For EKS run `. ./auth.sh && eks aws-personal`
- Initialize `terraform init`
- Deploy `terraform apply`
Output:

```sh
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://helm.releases.hashicorp.com"
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "1.0.3"
      + wait                       = true
      + wait_for_jobs              = false
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

- On completion
  
```sh 
elm_release.helm-consul-demo: Creating...
helm_release.helm-consul-demo: Still creating... [10s elapsed]
helm_release.helm-consul-demo: Still creating... [20s elapsed]
helm_release.helm-consul-demo: Still creating... [30s elapsed]
helm_release.helm-consul-demo: Still creating... [40s elapsed]
helm_release.helm-consul-demo: Still creating... [50s elapsed]
helm_release.helm-consul-demo: Creation complete after 58s [id=helm-consul-demo]
```

- Verify helm install 
`helm list`

```sh                                                                                 1 ✘  minikube ⎈
NAME            	NAMESPACE	REVISION	UPDATED                            	STATUS  	CHART       	APP VERSION
helm-consul-demo	default  	1       	2023-02-05 15:20:23.59376 -0800 PST	deployed	consul-1.0.3	1.14.4
```

- Using `kubectl`

```sh
kubectl get pods                                                                            ✔  minikube ⎈
NAME                                                            READY   STATUS    RESTARTS   AGE
helm-consul-demo-consul-connect-injector-6cc6b5b777-mbxjr       1/1     Running   0          89m
helm-consul-demo-consul-server-0                                1/1     Running   0          89m
helm-consul-demo-consul-webhook-cert-manager-7fb5f5c775-8lj9q   1/1     Running   0          89m
```

- Verify S3 bucket remote state. You should see `helm-consul-demo` in the bucket
![ S3 Bucket ](./images/Screen%20Shot%202023-02-05%20at%204.52.21%20PM.png)

- Verify helm-consul-demo-consul-ui by enabling kubectl port forwarding (EG `kubectl port-forward deployment/mongo 28015:27017`)
For example setup port forwarding to http://localhost:60590

![ UI ](./images/Screen%20Shot%202023-02-05%20at%2010.36.35%20PM.png)
![ UI ](./images/Screen%20Shot%202023-02-05%20at%2010.36.42%20PM.png)
![ UI ](./images/Screen%20Shot%202023-02-05%20at%2010.36.48%20PM.png)
![ UI ](./images/Screen%20Shot%202023-02-05%20at%2010.36.55%20PM.png)
![ UI ](./images/Screen%20Shot%202023-02-05%20at%2010.37.02%20PM.png)

## Destroy

- To destroy resources do `terraform destory`