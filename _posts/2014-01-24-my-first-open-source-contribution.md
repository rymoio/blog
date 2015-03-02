---
layout: post
title: My first open source contribution
date: 2014-01-24 23:49:10
category: technology
tags: [jekyll, sublime text]
type: text
---
In this post, I'd like to shamelessly plug my first open source community project [sublime-jekyll][sublimejekyll] - a Sublime Text package for easier Jekyll site creation. I created this out of a personal need for better syntax highlighting of YAML front-matter in markdown and HTML files, as well as template tag completions (since I always forget to close my opening template tags).

I've been a longtime user of open source projects like [Twitter Bootstrap][bootstrap] and [Django][django], however I never had the confidence or technical ability to actually contribute to these projects in any meaningful way. With my recent adoption of Jekyll as a static site generator, I decided it was time to give back to the community, while at the same time making my life easier as a Jekyll user.

I use Sublime Text as my plain text/code editor, and given the relatively easy ability to extend that tool, I decided to build my first Sublime package. Like many ST users, I'm a huge fan of [Package Control][packagecontrol] from wbond, and after reading the documentation on creating community accessible packages, I was determined to design one.

In creating my package, my goal was to speed my Jekyll site development process through the use of syntax highlighting, helpful template tag snippets, common code completions, and simple plugin functions. Much of what I put together in this package was done by users before me. It would be stupid not to thank the other contributors who I built off of - namely [liquid-syntax-mode][liquid] and [sublime-insertdate][insertdate].

In the end, I am very pleased with the package I created, and it seems like some of the Jekyll community is enjoying it as well. As of the publishing of this post, I had 150+ downloads of my package (not too shabby for a first-time contributor). If you want to try out Jekyll and you already use Sublime Text, I encourage you to install it today and let me know what you think!

> ### sublime-jekyll

> You can browse my Jekyll package for Sublime Text on the Package Control website

> [https://sublime.wbond.net/packages/Jekyll][sublimejekyll]

[sublimejekyll]: https://sublime.wbond.net/packages/Jekyll
[bootstrap]: http://getbootstrap.com/
[django]: https://www.djangoproject.com/
[packagecontrol]: https://sublime.wbond.net/
[liquid]: https://github.com/siteleaf/liquid-syntax-mode/
[insertdate]: https://github.com/FichteFoll/sublimetext-insertdate/