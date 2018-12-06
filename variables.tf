variable password {
  description = "Password for server root user"
}

variable master_disk_size {
  default     = 20
  description = "Size of master node disk(Unit:GB)"
}

variable master_server_core {
  default     = 2
  description = "Number of master node CPU core"
}

variable master_server_memory {
  default     = 4
  description = "Size of master node memory(Unit:GB)"
}

variable master_server_description {
  default = ""
}

variable master_server_tags {
  type    = "list"
  default = ["kubernetes-master"]
}

variable worker_disk_size {
  default     = 20
  description = "Size of worker node disk(Unit:GB)"
}

variable worker_server_core {
  default     = 2
  description = "Number of worker node CPU core"
}

variable worker_server_memory {
  default     = 4
  description = "Size of worker node memory(Unit:GB)"
}

variable worker_server_description {
  default = ""
}

variable worker_server_tags {
  type    = "list"
  default = ["kubernetes-worker"]
}

variable node_name_prefix {
  default = "kubernetes"
}

variable ssh_key_name {
  default = "kubernetes-ssh-key"
}

variable kubeadm_token {
  default     = ""
  description = "Token used by kubeadm init/join(generated if empty)"
}

variable worker_count {
  default     = 3
  description = "Number of worker node(allow zero)"
}

variable enable_master_isolation {
  default     = true
  description = "Flag not to schedule pod at master"
}

variable service_node_port_range {
  default     = "30000-32767"
  description = "A port range to reserve for services with NodePort visibility"
}

variable use_external_router {
  default     = false
  description = "Flag of to use switch+router for external network"
}

variable external_router_nw_mask_len {
  default     = 28
  description = "Length of switch+router's network mask"
}

variable external_router_band_width {
  default     = 100
  description = "BandWidth of switch+router's network(Unit:Mbps)"
}

locals {
  master_count                  = "${var.use_external_router ? 0 : 1}"
  router_connected_master_count = "${var.use_external_router ? 1 : 0}"
  worker_count                  = "${var.use_external_router ? 0 : var.worker_count}"
  router_connected_worker_count = "${var.use_external_router ? var.worker_count : 0}"

  master_node_count = "${var.use_external_router ? local.router_connected_master_count : local.master_count}"
  worker_node_count = "${var.use_external_router ? local.router_connected_worker_count: local.worker_count}"

  enable_master_isolation = "${var.worker_count > 0 ? "1" : "0"}"

  kube_internal_cidr     = "10.240.0.0/16"
  master_ip_start_index  = 240
  worker_ip_start_index  = 10
  pod_cidr               = "10.200.0.0/16"
  service_cidr           = "10.96.0.0/12"
  vpc_router_internal_ip = "${cidrhost(local.kube_internal_cidr, 1)}"
  external_count         = "${var.use_external_router ? 1 : 0}"

  master_node_name_prefix = "${var.node_name_prefix}-master-"
  worker_node_name_prefix = "${var.node_name_prefix}-worker-"
}
