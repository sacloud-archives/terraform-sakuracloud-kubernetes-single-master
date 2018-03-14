/******************************************************************************
 * for ssh to nodes
 *****************************************************************************/
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"

  provisioner "local-exec" {
    command = "mkdir -p ${path.root}/certs ; echo '${self.private_key_pem}' > ${path.root}/certs/id_rsa ; chmod 0600 ${path.root}/certs/id_rsa"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "rm -rf ${path.root}/certs"
  }
}
