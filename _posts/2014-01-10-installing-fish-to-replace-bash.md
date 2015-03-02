---
layout: post
title: Installing fish to replace bash
date: 2014-01-10 14:13:34
category: technology
tags: [configuration, fish]
type: code
---

[Fish][fish] is a bash shell replacement. I consider it a "better" version of the OS X bash shell. It supports a robust history with auto-completions, it pulls completion suggestions from installed man pages, and it looks prettier with user-configurable settings. You can also extend fish with custom functions (great for those commands you never remember, but use every so often).

### Installation
You can get Fish running with 3 easy steps:

{% highlight bash %}
# install with Homebrew
$ brew install fish

# add Fish to your list of shells
$ echo "/usr/local/bin/fish" | sudo tee -a /etc/shells

# make Fish your default shell
$ chsh -s /usr/local/bin/fish
{% endhighlight %}

### Basic Setup
Now that Fish is installed, let's configure it to be more helpful. First, create the Fish config directory. Then, create the initial config file:

{% highlight bash %}
$ mkdir -p ~/.config/fish
$ sublime ~/.config/fish/config.fish
{% endhighlight %}

Add the following lines of code to the file. This will add `/usr/local/bin` to the __PATH__ variable, as well as disable the default greeting/message that appears when you start Fish (this message can be changed later to whatever you like).

{% highlight bash %}
set -g -x PATH /usr/local/bin $PATH
set -g -x fish_greeting ''
{% endhighlight %}

If you open a new terminal shell, it should load directly into Fish, rather than Bash. If you want to alter your configuration further, type `fish_config` and wait for your browser to open (it should load _http://localhost:8000/_ automatically, but if it doesn't, try typing that into your browser's address bar).

As a last step, add some system-specific completions to the Fish shell. Do this by typing `fish_update_completions`.

If you ever need to access the Bash shell for a single session, just run `bash`. If you decide Fish isn't for you, you can revert to the Bash shell:

{% highlight bash %}
$ chsh -s /bin/bash
{% endhighlight %}

### Custom Configuration
If you'd like to customize your fish experience even further, you can start by modifying your `config.fish` file. Here is a look at what my file contains.

{% highlight bash %}
# general settings
set -g -x PATH /usr/local/bin $PATH
set -g -x ARCHFLAGS "-arch x86_64"
set BROWSER open
set -g -x EDITOR sublime
set -g -x VISUAL sublime

# fish prompt override
set -g -x fish_greeting ''

# helpful aliases
alias projects='cd ~/Projects'
alias virtualenvs='cd ~/Virtualenvs'
alias website='cd ~/Sites/website'
alias editbash='sublime ~/.bash_profile'
alias editfish='sublime ~/.config/fish/config.fish'
{% endhighlight %}

[fish]: http://fishshell.com/