resource sakuracloud_switch "kubernetes_internal" {
  name = "kubernetes-internal"
}

resource sakuracloud_vpc_router "vpc" {
  name = "kubernetes-vpc"
  plan = "standard"
}

resource sakuracloud_vpc_router_interface "eth1" {
  vpc_router_id = "${sakuracloud_vpc_router.vpc.id}"

  index       = 1
  switch_id   = "${sakuracloud_switch.kubernetes_internal.id}"
  ipaddress   = ["${local.vpc_router_internal_ip}"]
  nw_mask_len = 16
}

resource sakuracloud_vpc_router_static_route "worker_pod_network_routes" {
  vpc_router_id           = "${sakuracloud_vpc_router.vpc.id}"
  vpc_router_interface_id = "${sakuracloud_vpc_router_interface.eth1.id}"
  prefix                  = "${cidrsubnet(local.pod_cidr, 8, local.worker_ip_start_index + count.index)}"
  next_hop                = "${cidrhost(local.kube_internal_cidr, local.worker_ip_start_index + count.index)}"

  count = "${local.worker_node_count}"
}

resource sakuracloud_vpc_router_static_route "master_pod_network_routes" {
  vpc_router_id           = "${sakuracloud_vpc_router.vpc.id}"
  vpc_router_interface_id = "${sakuracloud_vpc_router_interface.eth1.id}"
  prefix                  = "${cidrsubnet(local.pod_cidr, 8, local.master_ip_start_index + count.index)}"
  next_hop                = "${cidrhost(local.kube_internal_cidr, local.master_ip_start_index + count.index)}"

  count = "${local.master_node_count}"
}
