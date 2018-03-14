module "kubernetes" {
  source = "sacloud/kubernetes-single-master/sakuracloud"

  /*********************************************
   * required
   *********************************************/
  // Password for server root user
  password = "<put-your-password-here>"

  // Number of worker node(allow zero)
  worker_count = 0

  /*********************************************
   * for master node spec
   *********************************************/

  // (optional) Size of master node disk(Unit:GB)
  // master_disk_size = 20

  // (optional) Number of master node CPU core
  // master_server_core = 2

  // (optional) Size of master node memory(Unit:GB)
  // master_server_memory = 4

  // (optional) Description of master node
  // master_server_description = ""

  // (optional) Tags of master node
  // master_server_tags = ["kubernetes-master"]

  /*********************************************
   * for worker node spec
   *********************************************/
  // (optional) Size of worker node disk(Unit:GB)
  // worker_disk_size = 20

  // (optional) Number of worker node CPU core
  // worker_server_core = 2

  // (optional) Size of worker node memory(Unit:GB)
  // worker_server_memory = 4


  // (optional) Description of master node
  // worker_server_description = ""

  // (optional) Tags of master node
  // worker_server_tags = ["kubernetes-worker"]


  /*********************************************
   * for other resource
  *********************************************/
  // (optional)
  // ssh_key_name = "kubernetes-ssh-key"

  // (optional)
  // node_name_prefix = "kubernetes"

  /*********************************************
  * for kubeadm
  *********************************************/
  // (optional)
  // kubeadm_token = ""

  /*********************************************
   * for kubernetes cluster vars
   *********************************************/
  // (optional) Flag of not to schedule pod at master
  //
  // If false, will execute following command when provisioning master node:
  //
  //    $ kubectl taint nodes --all node-role.kubernetes.io/master-
  //
  // enable_master_isolation = true
}
