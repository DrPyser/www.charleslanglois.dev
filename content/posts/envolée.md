+++
title = "Envolée"
date = "2024-01-26T23:51:53-05:00"
tags = ["meta", "web-hosting", "fly.io"]
keywords = []
description = "In which I relate my adventure with fly.io"
showFullContent = false
readingTime = false
hideComments = false
color = "" #color from the theme settings
+++
I recently deployed a new staging domain @ www2.charleslanglois.dev.
Instead of continuing using [vultr](https://www.vultr.com/) as the hosting provider, I decided to take the opportunity to try out [fly.io](https://fly.io).

They have a [very interesting technical model](https://fly.io/blog/docker-without-docker/) under their hosting strategy, which they love to talk about in lengths among other interesting topics, predictibly attracting nerdy-types like me like flies with vinegar.

One of the motivator for this exploration is cost, as the fly.io model seems optimized to drive down their cost of operation while still making their customers benefit from that cost saving, in effect spending just as much resources as the user actually needs and asks for.  
Why pay for a constantly spinning hard drive, heating CPU and constantly hot RAM when no one is actively using any of that? 
For a personal website that nobody visits(for now at least), I just want it to be available when someone knocks at the door(mostly me).  
"Scale to 0" and all that jazz.

Even so, fly.io will provides redundancy by default, by provisioning not one but two "machines"(basically VMs, technically "microVMs") behind their auto-configured and self-managed DNS.
Up to now, that cost me a big whopping $0.03 bucks.
Basically magic for pennies, from where I stand. 
Hopefully this blog won't get too popular anytime soon, lest I discover the price of actual use.

The other motivator is a simple, clean and practical build/deploy pipeline.
fly does the smart thing and relies on the modern popular deployment abstraction of OCI/docker images. But they don't actually deploy your stuff in containers, [that wouldn't be good enough](https://fly.io/blog/docker-without-docker/). But it matters little what they actually do with your OCI image, as long as it ends up exposing a routable IP and resolvable DNS that points to the right API, right?  
You get a nice [CLI interface](https://fly.io/docs/apps/) to do all the things, a [nice web interface](https://fly.io/dashboard), and not much in the way otherwise as far as I can see.              

Anyway, between that experiment and some other refactorings, which led to some issues with breaking changes in my dependencies, this ended up being a longer detour than expected.
But worthwhile, and currently satisfying.

I decided to redeploy my [main domain](https://www.charleslanglois.dev) to fly as well, given how simple and fun it is to use.

Hopefully I won't have any regrets!

Additional References:
- [Hugo's There - Flying with Hugo and Caddy](https://fly.io/blog/hugo-s-there-flying-with-hugo-and-caddy/)
