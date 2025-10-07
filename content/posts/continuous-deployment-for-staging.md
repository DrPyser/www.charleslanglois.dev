---
title: "Continuous deployment for staging"
date: "2025-10-05T19:48:46-04:00"
cover: ""
tags: ["meta", "website", "github-actions", "fly.io", "CD", "nix"]
keywords: []
description: "Notes on adding continuous deployment through github actions"
showFullContent: false
readingTime: false
draft: true
---

Just added a small upgrade to this website's maintenance workflow: continuous deployment to the staging grounds.

For context, this website has a staging counterpart at https://www2.charleslanglois.dev, also hosted on fly.io.
That way I can test changes without breaking the main "production" website at https://www.charleslanglois.dev .
Not that anyone would notice if I broke something, but *I* prefer knowing my website is up and functional. If I push some changes that break things, I can leave staging broken for a while, without impacting the prod version, that's a peace of mind I appreciate.

And fly.io makes it trivial to manage a second deployment environment.
Basically just need [an additional fly app configuration file](https://github.com/DrPyser/www.charleslanglois.dev/tree/da0b441fa2dff154368d5604d874fa60544318d8/fly/staging/fly.toml) and [a staging Caddyfile](https://github.com/DrPyser/www.charleslanglois.dev/tree/da0b441fa2dff154368d5604d874fa60544318d8/fly/staging/Caddyfile)(reverse proxy configuration).

That being said, up until now I had no automation for the deployment of this website, though I had [some minimal continuous integration](https://github.com/DrPyser/www.charleslanglois.dev/tree/da0b441fa2dff154368d5604d874fa60544318d8/.github/workflows/main.yml) that builds the website on every commit [using nix](https://github.com/DrPyser/www.charleslanglois.dev/tree/da0b441fa2dff154368d5604d874fa60544318d8/default.nix).

Every deployment action to either prod or staging was done by hand, though, which is fine considering how simple that is and how rarely I push updates up to now.
Now, with a small amount yaml in my github actions, any updates pushed to the main branch of the git repository is automatically deployed to my staging environment.

For production, I am still keeping it manual for now. That way, I can work fast and break things on staging, and only deploy on prod when I make a conscious decision and press the metaphorical red button.
Seems like a good tradeoff between simplicity, convenience and stability.

The github actions workflows are pretty trivial to configure, thanks to existing plugins(such [fly.io's own](https://github.com/marketplace/actions/github-action-for-flyctl)).
I only had to figure out the proper way to [securely inject secrets for different environments](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets#creating-secrets-for-an-environment).
Took a bit of digging in the docs and trial and error, but I got it working.

Now I can trust my staging to reflect the latest buildable version of my website's sources.

See ya in a next commit!
