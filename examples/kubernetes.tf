module "kubernetes" {
  source = "sacloud/kubernetes-single-master/sakuracloud"

  /*********************************************
   * required
   *********************************************/
  // (required) password
  //    Password for server root user
  password = "<put-your-password-here>"

  // (required) worker_count
  //    Number of worker node(allow zero)
  worker_count = 3

  /*********************************************
   * for external network setting
   *********************************************/
  // (optional) use_external_router
  //    Flag of to use switch+router for external networ
  // use_external_router = false

  // (optional) external_router_nw_mask_len
  //    Length of switch+router's network mask
  // external_router_nw_mask_len = 28

  // (optional) external_router_band_width
  //    BandWidth of switch+router's network(Unit:Mbps)
  // external_router_band_width = 100

  /*********************************************
   * for master node spec
   *********************************************/
  // (optional) master_disk_size
  //    Size of master node disk(Unit:GB)
  // master_disk_size = 20

  // (optional) master_server_core
  //    Number of master node CPU core
  // master_server_core = 2

  // (optional) master_server_memory
  //    Size of master node memory(Unit:GB)
  // master_server_memory = 4

  // (optional) master_server_description
  //    Description of master node
  // master_server_description = ""

  // (optional) master_server_tags
  //    Tags of master node
  // master_server_tags = ["kubernetes-master"]

  /*********************************************
   * for worker node spec
   *********************************************/
  // (optional) worker_disk_size
  //    Size of worker node disk(Unit:GB)
  // worker_disk_size = 20

  // (optional) worker_server_core
  //    Number of worker node CPU core
  // worker_server_core = 2

  // (optional) worker_server_memory
  //    Size of worker node memory(Unit:GB)
  // worker_server_memory = 4

  // (optional) worker_server_description
  //    Description of master node
  // worker_server_description = ""

  // (optional) worker_server_tags
  //    Tags of master node
  // worker_server_tags = ["kubernetes-worker"]

  /*********************************************
   * for other resource
   *********************************************/
  // (optional) ssh_key_name
  // ssh_key_name = "kubernetes-ssh-key"

  // (optional) node_name_prefix
  // node_name_prefix = "kubernetes"

  /*********************************************
   * for kubeadm
   *********************************************/
  // (optional) kubeadm_token
  // kubeadm_token = ""

  /*********************************************
   * for kubernetes cluster vars
   *********************************************/
  // (optional) enable_master_isolation
  //    Flag of not to schedule pod at master
  //    If false, will execute following command when provisioning master node:
  //
  //    $ kubectl taint nodes --all node-role.kubernetes.io/master-
  //
  // enable_master_isolation = true

  // (optional) service_node_port_range
  //   A port range to reserve for services with NodePort visibility
  // service_node_port_range = "80-32767"
}
