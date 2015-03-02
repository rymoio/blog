---
layout: post
title: Generating sitemaps with Jekyll
date: 2014-02-21 00:29:53
category: technology
tags: [jekyll, ruby]
type: code
---

It's always a good idea to include a `sitemap.xml` file for your site to help sites like Google track you and appropriately suggest page results in searches. There are a couple of Jekyll plugins that generate this file for you automatically ([here][generators] and [here][collections]), but I didn't like the ouput I was getting.

If you're looking for a simple way to generate a Jekyll sitemap without relying on plugins, here is a solution I borrowed from [Joel Glovier][sitemap]:

{% highlight xml linenos=table%}
{% raw %}
---
---
<?xml version="1.0" encoding="UTF-8"?>
<urlset
      xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
            http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">

{% for post in site.posts %}
<url>
    <loc>{{ site.url }}{{ post.url | remove: 'index.html' }}</loc>
    <changefreq>weekly</changefreq>
</url>
{% endfor %}
{% for page in site.pages %}
<url>
    <loc>{{ site.url }}{{ page.url | remove: 'index.html' }}</loc>
    <changefreq>weekly</changefreq>
</url>
{% endfor %}
</urlset>
{% endraw %}
{% endhighlight %}

The beauty in this solution is that it uses a blank YAML header to trigger Jekyll to compile it. Simply add this into your empty `sitemap.xml` file and enjoy.

---

It's best practice to let Google know about your sitemap file, and this can be done using Webmaster Tools, `robots.txt` or via HTTP. As your sitemap changes, you'll want to resubmit it ([read this][webmastertools]).

Again, you can do this using Webmaster Tools; or, if you opt for the HTTP method, I've written a relatively small ruby script that will attempt to resubmit your sitemap for you. Most of the bulk here is that I wanted the print out in the terminal to look pretty. If you don't like all the bulk, feel free to remove it.

{% highlight ruby %}
#!/usr/bin/env ruby

# Use this script to automatically submit a valid sitemap file to
# the Google Webmaster Tools endpoint.
#
# @params {String}: sitemap_url


require "CGI"
require "net/http"

# COLORS
cClear = "\033[0m"  # base
cFail = "\033[37;41m"  # red;bold
cSuccess = "\033[32;1m"  # green;bold
cWarning = "\033[33m"  # yellow
cInfo = "\033[34m"  # blue
cUrl = "\033[35;4m"  # purple;underline
cMisc = "\033[36;3m"  # cyan;italic

# GET ARGV
if ARGV[0]
  sitemap_url = ARGV[0]
else
  puts "A #{cInfo}sitemap url#{cClear} is a #{cFail}required#{cClear} argument!\n\n"
  exit
end

# URLS
base_url = "http://www.google.com/webmasters/tools/ping?sitemap="
webmaster_url = "https://www.google.com/webmasters/tools"

url = URI(base_url + CGI.escape(sitemap_url))

puts "Updating sitemap on Webmaster Tools...\n\n"

res = Net::HTTP.get_response(url)
code = res.code

case res
when Net::HTTPSuccess
  puts "#{cUrl}#{sitemap_url}#{cClear} was submitted #{cSuccess}successfully#{cClear}!\n\n"
else
  print "#{cUrl}#{sitemap_url}#{cClear} submit #{cFail}failed#{cClear} with code #{cWarning}#{code}#{cClear}.\n\n"

  a = [3, 2, 1]
  a.each {
    |n| puts "\t\tretrying in #{cMisc}" + n.to_s + " second" + (n == 1 ? "" : "s") + "#{cClear}..."
    sleep(1)
  }

  puts "\n"

  res2 = Net::HTTP.get_response(url)
  code2 = res2.code

  case res2
  when Net::HTTPSuccess
    puts "#{cUrl}#{sitemap_url}#{cClear} was re-submitted #{cSuccess}successfully#{cClear}!\n\n"
  else
    puts "#{cUrl}#{sitemap_url}#{cClear} re-submit #{cFail}failed#{cClear} again with code #{cWarning}#{code}#{cClear}.\n\n"
    puts "\nTry re-submitting manually via Webmaster Tools at #{cInfo}#{webmaster_url}#{cClear}.\n"
  end
end
{% endhighlight %}

[generators]: http://jekyllrb.com/docs/plugins/#generators_2
[collections]: http://jekyllrb.com/docs/plugins/#collections
[sitemap]: http://joelglovier.com/writing/sitemaps-for-jekyll-sites/
[webmastertools]: https://support.google.com/webmasters/answer/183669