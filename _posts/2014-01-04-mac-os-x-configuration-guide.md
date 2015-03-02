---
layout: post
title: Mac OS X configuration guide
date: 2014-01-04 21:51:52
category: technology
tags: [configuration, python, django, sublime text]
type: code
---

This guide is useful for setting up a new Mac development environment. The configuration guide is mainly meant to be used for a Mac that will serve as a local development machine for Python/Django, but you can obviously use some of these tips as general configuration options as well if Python isn't your development language of choice.

I'd also like to give lots of credit to Justin Mayer of the [Hacker Codex][codex] blog where I got many of the ideas for this post. I strongly encourage you visit his blog and read his articles. He has some great content to supplement what I've decided to include here.

### Prerequisites
To start, I recommend that you install the following Mac apps. I use them on a daily basis to make my development life much, much easier.

* [iTerm2][iterm]
* [Sublime Text 3][sublime]

After installing Sublime Text, enable command line access from the terminal shell. This will allow you to use `sublime filename` from the shell to open files in Sublime Text (note: by default, the terminal command is `subl`, but I like more descriptive aliases, so I use `sublime`).

{% highlight bash %}
$ ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime
{% endhighlight %}

### First steps
If your `~/Library` folder is hidden, un-hide it with the following shell command:

{% highlight bash %}
$ chflags nohidden ~/Library/
{% endhighlight %}

Set your compiler to always use 64 bits. Also override the default `PATH` so that Homebrew binaries take precedence over stock OS X binaries. To make these changes, first open `~/.bash_profile`:

{% highlight bash %}
$ sublime ~/.bash_profile
{% endhighlight %}

In the file that opens, add the following lines of text:

{% highlight bash %}
# Set architecture flags
export ARCHFLAGS="-arch x86_64"
# Ensure user-installed binaries take precedence
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
# Load .bashrc if it exists
test -f ~/.bashrc; and . ~/.bashrc
{% endhighlight %}

Refresh your file so the changes take effect:

{% highlight bash %}
$ . ~/.bash_profile
{% endhighlight %}

Ensure that you are the owner of the `/usr/local` directory to prevent having to use `sudo` all the time. If you don't know your _USER_ or _GROUP_ information, use the `id` command and grab the text in parentheses after _uid_ and _gid_:

{% highlight bash %}
$ sudo chown -R USER:GROUP /usr/local

# if you don't know your USER or GROUP...
$ id
uid=501(rymo) gid=20(staff) groups=20(staff)

$ sudo chown -R rymo:staff /usr/local

{% endhighlight %}

### Xcode
Download and install the latest version of [Xcode][xcode] from the Apple App Store. Once installed, open and agree to the terms and conditions (this is needed by additional packages later on). Also open up _Preferences > Downloads_ and install the _Command Line Tools_.

I would also suggest running the following command to ensure you have accepted the Xcode license agreement:

{% highlight bash %}
$ sudo xcodebuild -license
{% endhighlight %}

### RubyGems
[RubyGems][rubygems] gives you access to community managed Ruby gems. This should be installed on OS X by default, but likely is an outdated version. Upgrade your system version using this shell command:

{% highlight bash %}
$ gem update --system
{% endhighlight %}

### Homebrew
[Homebrew][homebrew] allows you to install packages on your Mac that are not installed by default. It is the much preferred successor to MacPorts. You can install it via the shell:

{% highlight bash %}
$ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
{% endhighlight %}

After installing, run the built-in environment check to make sure your system is ready to use Homebrew:

{% highlight bash %}
$ brew doctor
{% endhighlight %}

Any errors or issues found by the brew doctor are typically easy to remedy using the provided instructions. If you need to fix anything, do so and run `brew doctor` again. Once this returns cleanly, you can update to the latest version:

{% highlight bash %}
$ brew update
{% endhighlight %}

#### Optional step
Install some recommended packages. You can use `brew info package` to see what the packages do:

{% highlight bash %}
$ brew install bash-completion ssh-copy-id wget
{% endhighlight %}

If you decide to install __bash-completion__, you can auto-activate it by adding some text to your `~/.bash_profile`:

{% highlight bash %}
$ sublime ~/.bash_profile
{% endhighlight %}

Then paste the following at the bottom of the file:

{% highlight bash linenos=table %}
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
{% endhighlight %}

## Configuring Python and Virtualenv
This section outlines how to appropriately configure your environment for using Python and Virtualenv (as well as a few other items). If you aren't going to use Python for development, you can skip this section.

### Python
Update your system version of Python to the latest 2.x version. In addition, update the system version of OpenSSL:

{% highlight bash %}
$ brew install python --with-brewed-openssl
{% endhighlight %}

### Pip and Virtualenv
To install __virtualenv__, I highly recommend using __pip__. When doing this, packages are installed in `/usr/local/lib/python2.7/site-packages`, and binaries are placed in `/usr/local/bin`.

Install _virtualenv_ and create 2 new folders for your local development:

{% highlight bash linenos %}
$ pip install virtualenv
$ mkdir -p ~/Projects ~/Virtualenvs
{% endhighlight %}

The concept here is that you create new _virtualenvs_ inside `~/Virtualenvs` using:

{% highlight bash linenos %}
$ cd ~/Virtualenvs; virtualenv foobar
{% endhighlight %}

To activate a virtualenv, use:

{% highlight bash linenos %}
$ cd ~/Virtualenvs/foobar; . bin/activate
{% endhighlight %}

Then, navigate to your `~/Projects` folder to create your project files. To leave/exit your virtualenv, just type `deactivate` into the shell.

## Final Notes
You should now be ready to start using your Mac OS X environment for Python development. If you want to install some other things, here are some suggestions. I'll be adding some additional posts on how to enhance your bash shell using fish, as well as some suggested Sublime Text plugins for Python development. Hope this was helpful.

[codex]: http://hackercodex.com/
[iterm]: http://www.iterm2.com/
[sublime]: http://www.sublimetext.com/3
[xcode]: https://developer.apple.com/xcode/
[rubygems]: http://rubygems.org/
[homebrew]: http://brew.sh/