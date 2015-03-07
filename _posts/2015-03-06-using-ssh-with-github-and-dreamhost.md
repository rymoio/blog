---
layout: post
title: Using SSH with GitHub and Dreamhost
type: code
category: technology
published: true
tags: [ssh, git, github, dreamhost, configuration, osx]
---

In setting up my new Jekyll blog, I needed to do some research on setting up passwordless login to GitHub and Dreamhost on OS X. There are two main articles I used for doing this (see below), however I thought I would consolidate the steps to make setting this up easier. Keep in mind - these steps are strictly for Mac OS X. The articles linked at the end include instructions for other platforms.

## GitHub SSH

You can get this setup and working relatively quickly with these steps:

### 1. Generate a new SSH key

{% highlight bash %}
$ ssh-keygen -t rsa -C "your_email@example.com"
{% endhighlight %}

When prompted to enter a filename, I prefer to add a username suffix to make separate keys easier to manage and remember. So instead of accepting the default name of `id_rsa`, I add a suffix to make it `id_rsa_username`.

### 2. Add your key to the ssh-agent
{% highlight bash %}
# Start the ssh-agent service...
$ eval "$(ssh-agent -s)"

# Add your newly generated key...
$ ssh-add ~/.ssh/id_rsa_username
{% endhighlight %}

If you forget this step, you won't be able to successfully verify your configuration in Step 4 below.

### 3. Add your key to your GitHub account

{% highlight bash %}
# Copy the contents of the public SSH key to the clipboard...
$ pbcopy < ~/.ssh/id_rsa_username.pub
{% endhighlight %}

Once you have that copied, just log in to GitHub, click the _Settings_ cog-wheel in the top and choose _SSH Keys_ in the sidebar.

### 4. Verify it works

{% highlight bash %}
# Verify you can log in...
$ ssh -T git@github.com
{% endhighlight %}

If everything works, you should get a really confusing message saying you were successful but GitHub doesn't allow shell access. Don't worry - this is expected and you can ignore it. Enjoy passwordless git commits.

Read more on the [GiHub article][github-ssh].

### Bonus!

You'll want to make sure you start cloning repositories using the SSH option. This typically means your URLs will look like this - `git@github.com:USERNAME/REPOSITORY.git`. If you have existing repositories that are linked to remotes over HTTPS, you can quickly and easily change those remote URLs with the following git commands:

{% highlight bash %}
# Change from HTTPS to SSH...
$ git remote set-url origin git@github.com:USERNAME/REPOSITORY.git

# Verify the change...
$ git remote -v
origin  git@github.com:USERNAME/REPOSITORY.git (fetch)
origin  git@github.com:USERNAME/REPOSITORY.git (push)
{% endhighlight %}

Read more on the [GiHub article][github-seturl].

---

## Dreamhost SSH

Just like the GitHub setup above, there are a few easy steps:

### 1. Generate a new SSH key

{% highlight bash %}
$ ssh-keygen -t rsa -C "your_email@example.com"
{% endhighlight %}

Again, when prompted to enter a filename, I prefer to add a username suffix to make separate keys easier to manage and remember.

### 2. Copy your key to the Dreamhost server

The Dreamhost wiki says that this command doesn't work on OS X, but I had the opposite experience. I tried using the secondary approach and that didn't seem to work, so I tried this and it did. I'm going to recommend you start with this one and if it doesn't work, fall back on the second option in the article.

{% highlight bash %}
# Run this command and see if it works...
$ ssh-copy-id -i ~/.ssh/id_rsa_username.pub user@server.dreamhost.com

# If it doesn't work, try this...
$ cat ~/.ssh/id_rsa_username.pub | ssh user@server.dreamhost.com "cat >> ~/.ssh/authorized_keys"
{% endhighlight %}

### 3. Verify it works

{% highlight bash %}
# If you set this up correctly, you should see your Dreamhost shell...
$ ssh user@server.dreamhost.com
{% endhighlight %}

Read more on the [Dreamhost article][dreamhost-ssh].

[github-ssh]: https://help.github.com/articles/generating-ssh-keys/
[dreamhost-ssh]: http://wiki.dreamhost.com/SSH
[github-seturl]: https://help.github.com/articles/changing-a-remote-s-url/