---
title: "Adventure in telephonyland"
date: "2024-11-09T23:19:53-05:00"
tags: ["asterisk", "telephony", "sip", "homelab"]
description: "In which I talk endlessly about telephony and my personal adventure in deploying an Asterisk system at home"
showFullContent: false
readingTime: false
draft: false
toc: true
---

I've been wanting to publish something about telephony for a while.
The size of this post might be intimidating, so there's a table of content to skip around.

The first two sections are me rambling about the history of telephony, the rest is about my adventures in setting up an asterisk PBX in my home network.

## Telephony

So I've been on a trip through telephonyland for the last two years, since I've started working for a IP-PBX software company, [Wazo Communication](https://wazo.io).

Before that I knew nothing of telephony and its history, beside having heard of some concepts and technologies, like SS7, ISDN, SIP, "VoIP", if only in name.

I'm a millenial kid, born in the 90s, so I've seen and used almost exclusively "touch tone" phones(with button keys), wireless handsets and mobile phones all of my life.
I don't remember ever interacting with a rotary phone at home.  
Telephony as a feature of life was mostly a minor thing, part of the background, and I never gave it much thought.
What was hot, interesting and quickly expanding was the Internet and the Web.

Telephony is still here: many people still have home phones in some form or another, and mobile phones are still used as phones often enough.  
But in many ways "telephony" seems more a remnant of the past, suplanted by a plethora of alternatives based on various internet and web-based technologies.

Everything is digital, multi-media communication enabled by full-on computers nowadays.  
Voice is part of it, but always competing with all kinds of communication mediums and interfaces, such as text-based chatting, image sharing, automated screen-based interfaces(e.g. over the web), communication of pre-recordings.  
And so many different communication applications are competing with traditional telephony services, and there doesn't seem to be a lot of convergence towards standardization and interoperability in this modern jungle.

This is in contrast with the golden age of telephony, where the humble telephone pretty much dominated the landscape of telecommunication for the average person.
There was some competition from the telegraph, or later teletext, where asynchronous text communication was adequate and longer delays were acceptable.
And radio was used for broadcast communications, but the bulky and expensive electronics of the early to late 20th century didn't allow for easy point-to-point radio communication(of course cellular mobile technology changed that by the end of the century).  
So for normal synchronous person-to-person communication, there was really no other viable alternative to the landline. This was before personal computers became common place.

On top of this absence of technological diversity, the economic ecosystem of telecommunication in North America was based on a regulated monopoly.
So the dominant communication technology was largely controlled by a single corporation, The Bell Telephone Company[^wikibell], becoming AT&T[^wikiatt] alias Ma Bell.
This resulted in a strong incentive to standardize, for cost reduction and increased reliability.
This didn't stop innovations which implied cost reduction, such as improving the capacity of call exchanges, but perhaps limited innovation in customer-facing features, at least in their spread.
After all, when people don't have a choice of feature set, they can only be satisfied with what you give them. As long as reliability was guaranteed, people wouldn't complain.
And adding features increases complexity, which works against cost reduction and reliability.

The current market of telecommunication shows pretty much the opposite. People have many alternatives with varied feature sets.
There are many standards, but little incentives to standardize, as the profit is in differentiating the product to gain market share.

Interoperability is an afterthought, if present at all. People became used to either using multiple methods of communications since it became easy to install an app on a smartphone.
Else having their social group using the same technological stack as them.
Interoperability is also much harder since the technological stack is so much more diverse, and the physical layers are rapidly shifting.

Yet, voice remains an important part of human telecommunication for synchronous use cases.
We still want to hear each other talk.

Remote working reaffirmed

## The network

The telephone network is the original telecommunication network, and incidentally the original backbone infrastructure of the early internet.
The internet is really an offspring of the telephone network, an evolution that once was dependent on its parent, but has long since grown out of it, eaten it, and is now in the process of digesting it and making it part of itself. 
(Am I going to strong on this metaphor?)

It is curious to realise that what we still call "the telephone network", while heterogeneous across the world, is now, in many developed countries at least, mostly an overlay network over the current internet backbone infrastructure, reversing the situation of the internet's origin.  
The internet began as networks of computers, which were remotely accessible and interconnected (at least in part) through the telephone network.  
The physical infrastructure originally developed for [analog voice communication] became useful to interconnect computers and other digital equipments. But obviously the optimisations and constraints put in place for voice-only communication quickly became a frustrating limit for computer communication, so new infrastructure had to be developed.

That new infrastructure was envisioned as a new and improved telephone network that was also a data network, joining high-quality voice and high-bandwidth data services, as outlined in the [Integrated Services Digital Network](https://en.wikipedia.org/wiki/ISDN) vision.  
Most people are not aware of that term and vision, as it never really reached residential consumers in North America, and remained a background element of the consumer-level infrastructure.
It was a conception of a telecommunication network very different from what we now experience with the internet.
It involved high vertical integration of a stack of protocols, where the whole infrastructure from physical layer to application services were designed together, giving more control and significance to the operators of this network.

Contrast this with the internet we have, where the network operators, Internet Service Providers(ISPs), are more or less simply bit movers. They take care of the transport of bytes of data from one computer to another, using the IP protocol stack, and mostly don't care what those bytes are for(and most often nowadays cannot care given encryption of traffic between client and servers).
With the internet, you pay for bandwidth and access to the network. With enough bandwidth, there is really no limitation to the kinds and amounts of services you have access to with your internet connection.
The "service" of the ISP is agnostic to how you use it and what you do with it.

In the ISDN conception, you pay for application-level services, not simply for access to a network.  
Want access to your bank account? Subscribe to the remote banking service.  
Want mail? Subscribe to the email service.  
Each application of the network is a separate service that can be sold separately by the operators of the network.
The ISDN infrastructure makes it possible for new digital application services to be added, but mostly by collaboration and partnership with network operators.

The Internet Protocol stack won over the ISDN stack[^netvbell1][^netvbell2], and the internet infrastructure became solid enough for the telephony services to be ported over the internet infrastructure using Voice Over IP technologies.
Since the larger telephony providers are also the internet infrastructure providers, why should they maintain two separate network infrastructure and technology stacks?
Why not reuse one for the other?  
So if you have a landline nowadays, chances are that the voice signal of your telephone device, bet it analog or IP itself, goes through the same pipe as your internet & web traffic.
The voice traffic might be prioritized since it is time and bandwidth sensitive, but otherwise it's just IP packets over an IP network.

But Voice Over IP is not a single simple thing either of course.
There has been a number of standards, lots of them proprietary, used for voice over IP technologies([H.323], [SCCP][examples]), but nowadays some clear winners have emerged as open standards, such as the [Session Initiation Protocol(SIP)][^SIPRFC] for signaling, [Realtime Transport Protocol(RTP)] for media, Interactive Connectivity Establishment[^ICERFC] & Session Traversal Utilities for Nat(STUN)[^STUNRFC]/Traversal Using Relay NAT(TURN)[^TURNRFC] for connection establishment and [NAT] traversal, and WebRTC[^webrtcmdn] for the web stack.

SIP is a text protocol similar to(and inspired by) HTTP. The header part of a message contains `Header: Value` lines to convey all sorts of metadata.
Interestingly, it's not a simple Request-Response protocol like HTTP, in order to accomodate some of the complexities of telephony signaling and human interactions.
You have provisional responses, acknowledgments, referals, even publish/subscribe patterns(`SUBSCRIBE` and `NOTIFY`). Both client and server can send multiple messages in sequence, expecting one, multiple or no response.
It is really designed to be widely usable and extensible for any multi-media signaling use cases, including extensions(such as SIP SIMPLE[^sipsimpleietf]) to support text messaging.
Being broadly similar to HTTP in syntax and message structure, it's not too hard to work with and understand.
It is not exactly a simple protocol though, since the application domain is not simple, and some complexity comes from edge cases of feature support and non-standard behaviors, and sometimes the multiple ways to express some real-world behavior(though most use cases are standardized through RFCs).

## Asterisk

[Asterisk] is an open source software project started by [Mark Spencer] in the 90s. It implements a [PBX(Private Branch Exchange)] as software for linux OSes.
As a PBX, it enables any business or individual to manage their own internal phone system and connections to PSTN lines.
Given it's various APIs, it's also a toolkit and framework for building complex telephony applications and communication platforms.

This is what Wazo Communication, my employer, has done, where Asterisk is used as the core of our platform, providing a base set of features and connection interfaces, and more complex features or better interfaces are built on top using python services integrating with Asterisk through the ARI, AMI and AGI interfaces, enabling Wazo to target SMBs(small and medium businesses) as a more complete and user-friendy solution for business needs.

But Asterisk in itself is immensely useful and featureful and should cover most of my needs, and being a developer I'm not afraid to have to write some code if needs be.

## Home PBX: goals

So why install a PBX at home?

My main goal was to learn and have fun.

Another related goal was to make use of my collection of analog phones. "Make use" here being used in the vaguest sense of being functional and usable for something.

A basic actual use case is having a home intercom system, so that my partner can more effectively yell at me through the phone line instead of through the walls.

Unfortunately this also depends on having enough wired connections between rooms.
Ideally for me, every rooms (except bathrooms perhaps) would have a phone or ethernet jack.
But as it is there's only two, and the one in the bedroom is impractically located and unlikely to be used as it is.
Adding wiring to other rooms is another project in itself, but I'm hoping it's doable.

Another goal was to learn deeper practical knowledge of Asterisk and IP telephony, which could help me professionally.

## Analog phone collection

Since my interest in telephony started, I've been collecting analog phone sets.

Not collecting as in simply buying up all I can find, no no.
I'm selecting those phone sets that are in good conditions and have something special functionally.
Right now I have
- 3 butt sets[^buttsets],
- one Nortel 350(with a broken ADSI display),
- one [Meridian M9009](https://www.telephonemagic.com/nortel_meridian_vista_9009.htm),
- one Aastra 9216
- another Nortel phone
- one Nortel Jazz

One could say I don't need anymore, technically I don't need any of these.
I'm looking for diversity and feature set


## An ATA and a voip.ms number

Collecting old phones is nice and easy, but less fun, and harder to justify, if there's no way to use them.
I didn't want to pay for a landline at 25 bucks a month, but there's an alternative: finding(buying) an [Analog Telephone Adapter](https://en.wikipedia.org/wiki/Analog_telephone_adapter), or ATA.
Also called a SIP gateway device, it's a VoIP device that also acts as an analog phone line, simulating the electrical behavior of a phone exchange to an analog port, while being connecting to an ethernet/IP network, interpreting SIP messages into analog line signals, and analog line signals into SIP messages.

If a VoIP(SIP) call comes in, the ATA generates the ringing signal to the connected analog phone device/line.
Simultaneously, it signals to the calling system that it is ringing its endpoint.

When the phone handset is picked up(off-hook), the ATA detects the closed circuit and provides the current expected by a phone(~30-40mA).
It also detects DTMF tones, and during a call translates them to corresponding SIP/RTP events(if configured to), or outside of a call interpret them for local interaction with the ATA itself, or sends them out to the configured SIP server/registrar, depending on configuration(such as "dialplan" and timeout settings).

I got lucky and found one for 5 bucks on facebook marketplace, a [Grandstream HT801].

I started trying to use it directly, independently of any SIP registrar/server. This mode of behavior is called "direct IP calling". Basically, SIP supports peer-to-peer connections, such that a SIP user agent can directly contact another SIP user agent, without the need for an intermediary.
Once I connected the ATA to my network and to a phone set, I eventually got to call it directly using baresip on my laptop. I had to specify the sip address of the ATA, which is simply `sip:{anything}@{ip or hostname}`. The `{anything}` part is the "userpart" of a SIP address, and required but not useful in this case since the ATA does not support multiple lines and will behave the same no matter the value I use(e.g. `sip:phone@phoneline1.charlesnet` or `sip:me@phoneline1.charlesnet`).
Then I had to do something more: play a song from my laptop to the phoneline. I eventually succeeded in using baresip's "aufile" module to play a properly encoded file(WAV with ulaw,8000KHz rate). The sound is crappy, but the accomplishment is sweet.

That was enough for a short while, but the bigger goal loomed on the horizon.

## Asterisk deployment in homelab

I had already deployed an asterisk box in my homelab months earlier, before I moved into a new house.
Once I got to bringing my homelab back up, I could reboot the same VM, update it, and make sure the asterisk install was working.

It had some difficulties getting a working secure trunking setup with voip.ms.
I had to mess around to make sure I had an asterisk supporting SRTP, and finally I realised the culprit of my issues was a familiar one to networking and VoIP IT professionals.
![Scooby Doo unmasking the villain](scoobydoonat.jpg)

Yes, NAT strikes again.

Obviously, I'm in a NATed setup, with my asterisk separated from the internet by layer of routers, behind my ISP-provided public IP address.
So I ended up fixing the issues by providing the public IP as `external_media_address` and `external_signaling_address`[^asterisknat] options on the PJSIP transport configuration.

[config sample]

There may be alternative ways of making things work, without relying on TURN/STUN. After all, the voip.ms server can see my traffic comes from my public IP, and should be able to use the source IP of the packets.

I configured an asterisk PJSIP endpoint for my grandstream HT801 ATA, and another for my laptop, where I use [baresip](https://github.com/baresip/baresip) as a SIP softphone.
Thanks to pjsip_wizard.conf, endpoint and trunk configuration are simple and clean enough for my taste.
Now I had phones which could call each other and ring. I could even play music from my laptop to the phoneline using baresip `aufile` module!

I configured some test extensions in my local/default dialplan context, for example one to tell the time, an echo test, a milliwatt test, a "callback", and such.

I could also receive incoming calls from my voip.ms number, and make outgoing calls to the PSTN.

## IVR

The next milestone was building a simple IVR as a "front desk" to handle calls to my public voip.ms phone number.

This should help to filter out robocalls and spam callers, by challenging callers with the requirement to understand spoken words in french canadian, and make a choice accordingly.
This also allows "multiplexing" this one number into multiple ways to reach me and my partner, and also exposing other functionalities of my phone system to the public.

For this, I decided to record my own voice prompts, as this offers a personalized interface, so people who know me will recognize that they are indeed calling me, and not some cold, automatic synthesized-voice system  reminding them of being stuck with a call center IVR for insurance or banking.

I used audacity to record voice samples and export them as ulaw encoded WAV files, which I then converted to `ulaw`(without the WAV container) using `sox` command line tool.

[insert sox command]

I then copy over the ulaw files into the right asterisk directory on my asterisk node.

[insert rsync command]

Then I wrote some dialplan. Since I'm using `pbx_lua` module to write my dialplan using lua code, I defined a function to encapsulate this IVR and be able to reuse it in different contexts:
[insert lua IVR dialplan]

This is pretty simple workflow which I can easily repeat to build IVRs.

## future goals

### Expand home network

More ATAs and more integrated phone lines for individually addressable endpoints.

Expand phone wiring or ethernet cabling to other rooms. 

### Explore telephony features

The common features of a telephony system.
Such as call forwarding & call relocation, so that when I receive a call I can pickup on one phone then switch and continue on another device.

Also explore directory management. 

### Music jukebox

deploy a music server in my network, using something like music player daemon, and make its audio stream and control interface accessible through asterisk.
Use as "music on hold", or "dial-a-song" extension.

### Interconnect

Interconnect home asterisk system with other hobbyist VoIP networks such as Phreaknet, NTSPN, C*NET.

### XMPP

Deploy an XMPP node and integrate with asterisk.

Experiment with XMPP, integrate XMPP presence and chat with my asterisk system.

Analog phones might be limited to ringing for signaling, which is likely too annoying for real use cases. But could be fun to have phone rings everytime I receive a text.

Maybe using XMPP presence for call routing, such that asterisk route calls only to devices which have declared their presence as available through XMPP(or avoids calling devices which published an unavailable presence state).  
See for example [this article by Anthony Critelli](https://www.acritelli.com/blog/voice-and-xmpp-integrating-asterisk-with-ejabberd/).

XMPP can also be used as an alternative VoIP stack for signaling and media negociation[^jingle] as well as for instant chat(text) messaging and presence. Experiment with XMPP voice calls(maybe video as well), and bridge calls between asterisk and XMPP(see about using chan_motif for XMPP support in asterisk).
Ultimately, I could be reachable at home using both SIP-based telephony and PSTN connections(through voip.ms) but also through the XMPP federated network, and using something like [jmp.chat].

### Voice recognition

Explore using open source voice recognition software to understand/transcribe spoken words.

This enables powerful features, such as better directories and IVRs.
instead of listening for every possible options and selecting one using a numerical index, speak words and be understood.

[^wikibell]: https://en.wikipedia.org/wiki/Bell_Telephone_Company
[^wikiatt]: https://en.wikipedia.org/wiki/AT%26T
[^ISDN]: https://en.wikipedia.org/wiki/ISDN
[^netvbell2]: https://www.devever.net/~hl/sip-victory
[^netvbell1]: https://archive.gyford.com/1997/wired-uk/2.10/features/netheads.html
[^SIPRFC]: https://www.rfc-editor.org/rfc/rfc3261.html
[^RTPRFC]: https://www.rfc-editor.org/rfc/rfc3550
[^ICERFC]: https://www.rfc-editor.org/rfc/rfc8445
[^STUNRFC]: https://www.rfc-editor.org/rfc/rfc5389
[^TURNRFC]: https://www.rfc-editor.org/rfc/rfc5766
[^webrtcmdn]: https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API
[^sipsimpleietf]: https://datatracker.ietf.org/wg/simple/documents/
[^buttset]: https://en.wikipedia.org/wiki/Lineman%27s_handset
[^asterisknat]: https://docs.asterisk.org/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Configuring-res_pjsip-to-work-through-NAT/
[^jingle]: https://xmpp.org/extensions/xep-0166.html
