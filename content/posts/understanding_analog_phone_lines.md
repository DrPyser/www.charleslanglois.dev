---
title: "Understanding analog phone lines"
date: "2024-11-09T17:44:13-05:00"
cover: ""
tags: ["telephony", "analog"]
keywords: []
description: "In which I relate my satisfaction at gaining a better understanding of analog phone lines"
draft: false
---

For a while I thought I understood analog phone lines but I didn't.
I'm a newbie at most things, basic electronics and electrical systems included, so this shouldn't be any surprise.

I thought analog phone lines were simple 48VDC circuits. What I had read on the subject left me that idea[^1][^2].
Of course I didn't do the math, didn't take field measurements. So I got confused a few times while reading and experimenting.

Then I somehow cobbled a few information sources together, and went on making field measurements to prove an hypothesis, then the understanding came: phone lines and phone exchange cicuits behave like a [current source](https://en.wikipedia.org/wiki/Current_source).

Analog telephone sets are designed to operate nominally with a current of ~20-40mA[^3], and the phone line will try to maintain that current flow when the circuit is closed, that is when a phone is taken off hook.

When the circuit is open, the line voltage is 48VDC, but as soon as the phone is off the hook, the circuit closes and the voltage drops down to about ~7V, as the phone presents a standard ~200 Ohm impedance to the line.
Why? Well by Ohm's law, `A = V / R` so `7 / 200 ~= 0.035A`(35mA). The voltage drops, because the impedance goes from infinity to 200. At infinite impedance, the nominal voltage is 48V but the current is 0.
At a 200 Ohm impedance, the voltage must drop because the current must be at a fixed target of 35mA(could be different depending on the phone line, values between 30mA and 40mA seem common)

So if I plug a multimeter on a phone line in parallel connection with phone set, which I did, I can measure 48VDC when the phone is on hook, and 7V when I take the phone off hook.
If I connect the multimeter in series for current measurement, I can consistently measure 35mA flowing when the phone is off hook, with little variation if I'm pressing touch tone buttons or speaking.

The key learning is that the voltage will change for the sake of providing a constant current.
The circuit at the end of the line in the central office is measuring the current flow and controlling the voltage to maintain that current at some preconfigured level. This kind of circuit is called a current source.

Now this makes simulating a phone line somewhat more tricky, since I can't just put a fixed 48VDC voltage source on the line, that could fry the phones as taking a phone off hook would feed them a current of `48 / 200 = 0.24A`(240mA) which means about 11W.

I could put a lower ~7V fixed voltage source, which would be fine for a single phone, or ~15V for two phones, etc.
But such a static voltage setup is pretty limiting, and the circuit needs to be overhauled for any addition of a phone set.
Anyway for a simple fixed intercom setup that is fine, and you can find such designs easily.

For something closing in to a true phone exchange, one needs to start with a current source.
Some simple designs based on a few transistors exist, which I experimented with but with little success.
Dedicated integrated circuits also exist, which would be the sensible route for a serious design for a DIY analog phone exchange.

I've mostly put that goal on pause while I invest more in my homelab and asterisk-based setup, which is more in comfort zone.

In any case this new understanding allows me to be satisfied for now, knowing what I need to go further if I want to continue building a DIY analog phone exchange.

[^1]: https://en.wikipedia.org/wiki/Telephone_line
[^2]: https://www.sandman.com/knowledgebase/analog-telephony-past-and-present
[^3]: https://www.sandman.com/knowledgebase/telephone-line-diagnostics
