---
layout: post
title: Chrome Note Tab browser extension
date: 2014-01-29 06:44:53
category: technology
tags: [javascript, html5, chrome extension]
type: text
---
I created a Chrome browser extension called [chrome-newtab][newtab]. It allows you to quickly take simple text based notes and display them as note cards in your browser. It overrides the standard new tab page so that all of your notes are always readable when you start your browser or open a new tab. I also added some goodies like keyboard shortcuts and a popup quick-entry screen (for entering notes away from the new tab page).

I spend almost all of my time at the office logged into my machine, so the one thing I know I will look at multiple times a <del>day</del> hour is my browser. After looking over a number of note apps that were very fancy and required the use of login creds and account creation, I built an HTML5 note taking app as a browser extension. It's certainly not perfect, as it doesn't support mobile or multi-machine syncing, but it does get rid of most of the sticky notes on my desk. The app itself uses HTML5 localStorage with the help of [store.js][storejs] with a custom JavaScript wrapper I built for quickly adding/deleting/updating my custom note object.

Give it a try. I'd love any feedback you have.

[newtab]: https://bitbucket.org/rmorrissey23/chrome-newtab/
[storejs]: https://github.com/marcuswestin/store.js/