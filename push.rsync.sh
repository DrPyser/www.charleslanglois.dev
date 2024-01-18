HOST=${HOST:-${1:-pursuit}}
PATH=www.charleslanglois.dev
rsync -avzP -e 'ssh -F hosts/ssh_config' ./public/ rsync://$HOST/$PATH
