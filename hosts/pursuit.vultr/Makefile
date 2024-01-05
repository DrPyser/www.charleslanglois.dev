HOST:=pursuit.vultr
SSH_CONFIG:=../ssh_config
.PHONY: sync/rsyncd
sync/rsyncd: rsyncd.conf
	scp -F $(SSH_CONFIG) rsyncd.conf $(HOST):/etc/rsyncd.conf
