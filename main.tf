/******************************************************************************
 * SSH public key
 *****************************************************************************/
resource sakuracloud_ssh_key "ssh_key" {
  name       = "${var.ssh_key_name}"
  public_key = "${tls_private_key.ssh_key.public_key_openssh}"
}

/******************************************************************************
 * Startup Script
 *****************************************************************************/

// for master
resource "sakuracloud_note" "master_provisioning" {
  name    = "${local.master_node_name_prefix}${format("%02d", count.index+1)}"
  content = "${data.template_file.master_provisioning.*.rendered[count.index]}"

  count = "${local.master_node_count}"
}

// for workers
resource "sakuracloud_note" "worker_provisioning" {
  name    = "${local.worker_node_name_prefix}${format("%02d", count.index+1)}"
  content = "${data.template_file.worker_provisioning.*.rendered[count.index]}"

  count = "${local.worker_node_count}"
}

/******************************************************************************
 * Nodes
 *****************************************************************************/
data sakuracloud_archive "centos" {
  os_type = "centos"
}

// disk for master
resource sakuracloud_disk "master_disks" {
  name              = "${local.master_node_name_prefix}${format("%02d", count.index+1)}"
  source_archive_id = "${data.sakuracloud_archive.centos.id}"
  size              = "${var.master_disk_size}"

  description = "${var.master_server_description}"
  tags        = ["${var.master_server_tags}"]

  lifecycle {
    ignore_changes = ["source_archive_id"]
  }

  count = "${local.master_node_count}"
}

// server for master
resource sakuracloud_server "masters" {
  name   = "${local.master_node_name_prefix}${format("%02d", count.index+1)}"
  tags   = ["kubernetes", "master"]
  core   = "${var.master_server_core}"
  memory = "${var.master_server_memory}"

  additional_nics = ["${sakuracloud_switch.kubernetes_internal.id}"]
  disks           = ["${sakuracloud_disk.master_disks.*.id[count.index]}"]

  description = "${var.master_server_description}"
  tags        = ["${var.master_server_tags}"]

  ssh_key_ids     = ["${sakuracloud_ssh_key.ssh_key.id}"]
  note_ids        = ["${sakuracloud_note.master_provisioning.*.id[count.index]}"]
  hostname        = "${local.master_node_name_prefix}${format("%02d", count.index+1)}"
  password        = "${var.password}"
  disable_pw_auth = true

  count = "${local.master_count}"
}

// server for master(connected to switch+router)
resource sakuracloud_server "router_connected_masters" {
  name   = "${local.master_node_name_prefix}${format("%02d", count.index+1)}"
  tags   = ["kubernetes", "master"]
  core   = "${var.master_server_core}"
  memory = "${var.master_server_memory}"

  nic             = "${sakuracloud_internet.kubernetes_external.switch_id}"
  ipaddress       = "${sakuracloud_internet.kubernetes_external.ipaddresses[count.index]}"
  nw_mask_len     = "${sakuracloud_internet.kubernetes_external.nw_mask_len}"
  gateway         = "${sakuracloud_internet.kubernetes_external.gateway}"
  additional_nics = ["${sakuracloud_switch.kubernetes_internal.id}"]
  disks           = ["${sakuracloud_disk.master_disks.*.id[count.index]}"]

  description = "${var.master_server_description}"
  tags        = ["${var.master_server_tags}"]

  ssh_key_ids     = ["${sakuracloud_ssh_key.ssh_key.id}"]
  note_ids        = ["${sakuracloud_note.master_provisioning.*.id[count.index]}"]
  hostname        = "${local.master_node_name_prefix}${format("%02d", count.index+1)}"
  password        = "${var.password}"
  disable_pw_auth = true

  count = "${local.router_connected_master_count}"
}

// disk for workers
resource sakuracloud_disk "worker_disks" {
  name              = "${local.worker_node_name_prefix}${format("%02d", count.index+1)}"
  source_archive_id = "${data.sakuracloud_archive.centos.id}"
  size              = "${var.worker_disk_size}"

  description = "${var.worker_server_description}"
  tags        = ["${var.worker_server_tags}"]

  lifecycle {
    ignore_changes = ["source_archive_id"]
  }

  count = "${local.worker_node_count}"
}

// server for workers
resource sakuracloud_server "workers" {
  name   = "${local.worker_node_name_prefix}${format("%02d", count.index+1)}"
  tags   = ["kubernetes", "master"]
  core   = "${var.worker_server_core}"
  memory = "${var.worker_server_memory}"

  additional_nics = ["${sakuracloud_switch.kubernetes_internal.id}"]
  disks           = ["${sakuracloud_disk.worker_disks.*.id[count.index]}"]

  description = "${var.worker_server_description}"
  tags        = ["${var.worker_server_tags}"]

  ssh_key_ids     = ["${sakuracloud_ssh_key.ssh_key.id}"]
  note_ids        = ["${sakuracloud_note.worker_provisioning.*.id[count.index]}"]
  hostname        = "${local.worker_node_name_prefix}${format("%02d", count.index+1)}"
  password        = "${var.password}"
  disable_pw_auth = true

  count = "${local.worker_count}"
}

// server for workers(connected to switch+router)
resource sakuracloud_server "router_connected_workers" {
  name   = "${local.worker_node_name_prefix}${format("%02d", count.index+1)}"
  tags   = ["kubernetes", "master"]
  core   = "${var.worker_server_core}"
  memory = "${var.worker_server_memory}"

  nic         = "${sakuracloud_internet.kubernetes_external.switch_id}"
  ipaddress   = "${sakuracloud_internet.kubernetes_external.ipaddresses[count.index+1]}"
  nw_mask_len = "${sakuracloud_internet.kubernetes_external.nw_mask_len}"
  gateway     = "${sakuracloud_internet.kubernetes_external.gateway}"

  additional_nics = ["${sakuracloud_switch.kubernetes_internal.id}"]
  disks           = ["${sakuracloud_disk.worker_disks.*.id[count.index]}"]

  description = "${var.worker_server_description}"
  tags        = ["${var.worker_server_tags}"]

  ssh_key_ids     = ["${sakuracloud_ssh_key.ssh_key.id}"]
  note_ids        = ["${sakuracloud_note.worker_provisioning.*.id[count.index]}"]
  hostname        = "${local.worker_node_name_prefix}${format("%02d", count.index+1)}"
  password        = "${var.password}"
  disable_pw_auth = true

  count = "${local.router_connected_worker_count}"
}
