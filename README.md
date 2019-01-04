# Kubernetes(Single Master)

This module deploys single-master Kubernetes cluster to SAKURA Cloud using `kubeadm`.  

**This project is for develop environment, so please do not use this in production**

## Overview

![overview.png](https://raw.githubusercontent.com/sacloud/terraform-sakuracloud-kubernetes-single-master/master/images/overview.png)

## Getting Started

### Prerequisites

- [Terraform](https://terraform.io)
- [Terraform for SAKURA Cloud(community provider)](https://github.com/sacloud/terraform-provider-sakuracloud)
- (Optional) [SAKURA Cloud CLI `usacloud`](https://github.com/sacloud/usacloud)

### Customize the deployment

Customizations to the base installation are made to the Terraform variables for each deployment.  
Examples of variables are provided in the file [`examples/kubernetes.tf`](https://github.com/sacloud/terraform-sakuracloud-kubernetes-single-master/blob/master/examples/kubernetes.tf).

### Initialize and configure Terraform

#### Get Terraform's SAKURA Cloud modules and providers

Get the modules and providers that Terraform will use to create the cluster resources:

```bash
$ terraform init
```

### Deploy the cluster

Test the blueprint before deploying:

```bash
$ terraform plan
```

Next, deploy the cluster:

```bash
$ terraform apply
```

This should run for a short time, and when complete, the cluster should be ready.

### Access the cluster

#### Access to nodes with `ssh`

Nodes credentials are written beneath the `certs/` directory.
You can use this to access the cluster by ssh.

```bash
$ usacloud server ssh -i certs/id_rsa <your-node-name>
```

#### Using `kubectl`

To use `kubectl` command on the local machine, you need to download the `kubeconfig` file as follows:

```bash
$ usacloud server scp -i certs/id_rsa <your-master-node-name>:/etc/kubernetes/admin.conf ./admin.conf
$ export KUBECONFIG=$(pwd)/admin.conf
$ kubectl cluster-info
```

## License

 `terraform-sakuracloud-kubernetes-single-master` Copyright (C) 2018-2019 Kazumichi Yamamoto.

  This project is published under [Apache 2.0 License](https://github.com/sacloud/terraform-sakuracloud-kubernetes-single-master/blob/master/LICENSE.txt).
  
## Author

  * Kazumichi Yamamoto ([@yamamoto-febc](https://github.com/yamamoto-febc))
