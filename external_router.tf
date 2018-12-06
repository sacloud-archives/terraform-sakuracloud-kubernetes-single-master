resource sakuracloud_internet "kubernetes_external" {
  name        = "kubernetes-external"
  nw_mask_len = "${var.external_router_nw_mask_len}"
  band_width  = "${var.external_router_band_width}"

  count = "${local.external_count}"
}
