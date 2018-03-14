# join
kubeadm join --token=${token} --discovery-token-unsafe-skip-ca-verification ${master_url}

# Setup CNI plugin(bridge)
mkdir -p /etc/cni/net.d
cat <<EOF > /etc/cni/net.d/10-cbr0.conf
{
	"name": "cbr0",
	"type": "bridge",
	"bridge": "cbr0",
	"isDefaultGateway": true,
	"forceAddress": false,
	"ipMasq": true,
	"ipam": {
		"type": "host-local",
        "ranges": [
          [{"subnet": "${pod_cidr}"}]
        ],
        "routes": [{"dst": "0.0.0.0/0"}]
	}
}
EOF
cat >/etc/cni/net.d/99-loopback.conf <<EOF
{
	"type": "loopback"
}
EOF

