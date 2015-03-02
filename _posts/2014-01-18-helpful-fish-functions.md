---
layout: post
title: Helpful fish functions
date: 2014-01-18 09:17:37
category: technology
tags: [configuration, fish, jekyll]
type: code
---
Here are some helpful fish functions I've added to my configuration to make dealing with the terminal easier.

First of all, I use [iTerm2][iterm] as a Mac terminal replacement. It's worth it. I talked about installing and setting up fish in my last post ["Mac OS X configuration guide"][macosx], so I won't cover that again.

All fish functions are stored in a `functions` folder. You can usually find it here.

{% highlight bash %}
$ cd ~/.config/fish/functions/
{% endhighlight %}

To add a new function, create a new file with a `.fish` extension and add it to this folder. When you restart the terminal, you will be able to use the function. The quickest way to add this file without leaving the terminal (and having to drag/drop a new blank file into your Finder window), is to source a new file.

{% highlight bash %}
$ source filename.fish
{% endhighlight %}

### Simple Mac functions

Show hidden files and then hide them again with 2 simple terminal commands. I created them as separate files `showall.fish` and `hideall.fish` respectively.

{% highlight bash %}
function showall --description 'Show hidden files in Finder'
  defaults write com.apple.finder AppleShowAllFiles TRUE; and killall Finder
end
{% endhighlight %}

{% highlight bash %}
function hideall --description 'Hide hidden files in Finder'
  defaults write com.apple.finder AppleShowAllFiles FALSE; and killall Finder
end
{% endhighlight %}

### Django virtualenv functions

This function assumes you have 2 folders in your User directory: `Virtualenvs` and `Projects`. If that is true, it will allow you to activate a virtualenv and move you to your project folder automatically using `workon` plus the project name.

{% highlight bash linenos=table %}
function workon --description 'Activate virtualenv and goto project folder'
  if [ (count $argv) -lt 1 ]
    echo You must specify a virtualenv!\n
    return 1
  end
  builtin cd ~/Virtualenvs/$argv[1]
  . bin/activate.fish
  builtin cd ~/Projects/$argv[1]
  echo Now working on $argv[1]...\n
end
{% endhighlight %}

To stop working on a virtualenv, just use the `stopworkon` command.

{% highlight bash linenos=table %}
function stopworkon --description 'Deactivate virtualenv'
  if [ (count $argv) -lt 1 ]
    echo You must specify a virtualenv!\n
    return 1
  end
  deactivate
  builtin cd ~/
  echo No longer working on $argv[1]...\n
end
{% endhighlight %}

### Minify LESS files

There are many ways you can compiles your LESS files into a minified CSS file. One of those ways is to use the command line tools supplied by `lessc`. Once that is installed, created this function and run it within your `static/` or `assets/` directory (which should contain both your `less/` and your `css/` directories).

{% highlight bash linenos=table %}
function minless --description 'Minify all less files in a less directory into
a css directory at the same level'
  echo \nMinifying (count less/*.less) less file\(s\) and outputing as\:
  for F in less/*.less
    set -l REGEXP (echo $F | sed -e "s/less\//css\//" -e "s/\.less/\.min\.css/")
    lessc -x $F $REGEXP | echo "- $REGEXP"
  end
  echo \n
end
{% endhighlight %}

### Buliding your Jekyll site

You can then combine multiple functions where appropriate. For building my Jekyll site, I like to compile all of my less files first, then build the site.

{% highlight bash linenos=table %}
function build_website --description 'Prepare website directory for
synchronization to a web server.'
  builtin cd ~/Sites/website/assets
  echo \nMinifying all less files\:
  minless
  echo \n

  builtin cd ../
  echo \nBuliding Jekyll site files\:
  jekyll build -t

  echo \nComplete!
end
{% endhighlight %}

Hope you find these helpful. As I get more involved with fish I'm sure I'll be adding more functions to improve my workflow.


[iterm]: http://www.iterm2.com/
[macosx]: {% post_url 2014-01-04-mac-os-x-configuration-guide %}