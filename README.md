---
title: "cppcalc"
author: "martin sneath"
date: "22 April, 2015"
output: html_document
---
In Canada you have a choice of collecting your pension any time from 60 on.

I wanted to know if my pension was going down at a time of low income so I wrote the calc here in R and it was a nice piece of code. A whole bunch of stuff in the calc is left out: disability, child rearing, over 65 because it did not apply to me.

Then after I found it was not going down I wanted to find the break points for my own mortality (hard to predict) at which it would have made more sense to start collecting. This 2nd part of the code is not so nice - I just wanted the answer. Turns out the answer was collect now, not later.

At some point I might come back to this and make it more comprehensive and better code, but for now: if someone has a similar question this might save them a few hours coding