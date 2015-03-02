---
layout: post
title: Font Awesome icons Jekyll tag plugin
date: 2014-01-25 09:49:55
category: technology
tags: [jekyll, ruby]
type: code
---
I wrote a simple Jekyll plugin that allows you to quickly add [Font Awesome][1] icons to your posts and pages. Feel free to copy the code snippet below to your `_plugins` directory in your Jekyll site, or you can view the source gist here - [font-awesome.rb][2].

{% raw %}
* Simplest usage looks like this: `{% icon fa-camera-retro %}`
* You can also add sizes: `{% icon fa-camera-retro fa-2x %}`
* Or set fixed width: `{% icon fa-camera-retro fa-fw %}`
* Or apply spinning: `{% fa-spinner fa-spin %}`
* Or apply rotating: `{% fa-shield fa-rotate-90 %}`
{% endraw %}

The only prerequisite for using this is that you have a link to the <em>font-awesome</em> stylesheet somewhere on your site. If you don't want to host the file locally, you can grab it from the netdna CDN:

{% highlight html %}
{% raw %}
<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
{% endraw %}
{% endhighlight %}

---

{% highlight ruby linenos=table %}
module Jekyll
  class FontAwesomeTag < Liquid::Tag

    def render(context)
      if tag_contents = determine_arguments(@markup.strip)
        icon_class, icon_extra = tag_contents[0], tag_contents[1]
        icon_tag(icon_class, icon_extra)
      else
        raise ArgumentError.new <<-eos
Syntax error in tag 'icon' while parsing the following markup:

  #{@markup}

Valid syntax:
  for icons: {% icon fa-camera-retro %}
  for icons with size/spin/rotate: {% icon fa-camera-retro fa-lg %}
eos
      end
    end

    private

    def determine_arguments(input)
      matched = input.match(/\A(\S+) ?(\S+)?\Z/)
      [matched[1].to_s.strip, matched[2].to_s.strip] if matched && matched.length >= 3
    end

    def icon_tag(icon_class, icon_extra = nil)
      if icon_extra.empty?
        "<i class=\"fa #{icon_class}\"></i>"
      else
        "<i class=\"fa #{icon_class} #{icon_extra}\"></i>"
      end
    end
  end
end

Liquid::Template.register_tag('icon', Jekyll::FontAwesomeTag)
{% endhighlight %}

[1]: http://fontawesome.io/
[2]: https://gist.github.com/23maverick23/8532525