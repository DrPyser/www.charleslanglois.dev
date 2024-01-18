+++
title = "Rebirth"
date = "2024-01-13T16:21:42-05:00"
tags = ["meta", "hosting", "web", "webfinger"]
description = "In which I provide some update on this website"
showFullContent = false
readingTime = false
+++

Okay, maybe "rebirth" is a tad overdramatic.

I just redeployed this website on a new server.
The previous one was an nginx server running on a debian buster os.
Spawned a new vultr instance, and decided on trying out Rocky Linux 8 instead.
Also swapped the webserver for [Caddy](https://caddyserver.com/), for the sake of simpler configuration and operation(automatic HTTPS for the win).

Otherwise everything should look the same.

Oh, and experimented with [webfinger](https://webfinger.net/) support through a [simple static file](/.well-known/webfinger). Nothing really useful for now, but costs little effort.

