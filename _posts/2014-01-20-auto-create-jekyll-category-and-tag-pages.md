---
layout: post
title: Auto-create Jekyll category and tag pages
date: 2014-01-20 21:36:18
category: technology
tags: [jekyll, ruby]
type: code
---
One of the things that Jekyll makes super simple is the use of categories and tags. However, being able to filter by and generate pages for specific categories and tags is a little more challenging. Coming from more of a Python background, I wasn't thrilled to learn that in order to do this I would have to write a custom generator plugin in Ruby (a language I don't know very well at all). This post outlines how I created my plugin in case someone else finds this helpful in the future.

A little background first: although both categories and tags operate almost identically, I decided to use categories in the singular, while using tags in a more traditional sense. Limiting myself to only placing a post in one category gives my site more rigidity, while tags give me the freedom to make finding my posts easy for anyone visiting.

The way I wanted my blog to look, which is different from the default setup, is that all post permalinks would follow a simple structure.

{% highlight yaml %}
permalink: /blog/:year/:month/:day/:title/
{% endhighlight %}

This gives my permalinks a cleaner look to them (rather than the [default URL implementation][permalink] which prepends category directories before the date sub-directories, and also keeps the `.html` extension which I find ugly).

{% highlight yaml %}
permalink: /:categories/:year/:month/:day/:title.html
{% endhighlight %}

But I digress. The reason this is important is that I still wanted visitors to be able to filter my posts based on category or tag. In order to do this, I would need separate `:category` and `:tag` directories containing all posts related to that reference. My first attempt at doing this was to manually create a sub-directory and `index.html` template for each reference. This, however, it completely non-scalable and requires a significant amount of effort. A quick read of the Jekyll Plugin docs revealed an [example][generators] that used as the basis for my custom implementation. Read on to see my documented changes, or [skip to the end][postend] to read the source code.

> REMINDER: If you want to see how this implementation works, feel free to poke around this blog. I use the code posted here to generate this blog.

## Changes and customizations

In order to make the Jekyll example work for my specific implementation, I ended up adding a few customizations. First, I created some settings in my `_config.yml` file to control the URL of my tag directory, as well as the page title prefix and the specific layout file to use in the `_layouts` folder.

#### _config/yml

{% highlight yaml %}
blog:
    tags:
        url: /blog/tags/
        title_prefix: "blog - tag: "
        layout: tag.html
{% endhighlight %}

#### Jekyll::TagPage

{% highlight ruby %}
# this line in the generator example
self.read_yaml(File.join(base, '_layouts'), 'category_index.html')

# becomes this line using custom config arguments
self.read_yaml(File.join(base, '_layouts'), site.config['blog']['tags']['layout'])
{% endhighlight %}

Second, I added a very simple regexp to remove spaces from tag names and replace them with dashes. This allows two things: 1) sub-directory folders are more URI friendly, especially when using hyperlinks; 2) this keeps naming conventions of posts and sub-directories consistent.

#### Jekyll::TagPageGenerator

{% highlight ruby %}
# this for block in the generator example
site.categories.keys.each do |category|
  site.pages << CategoryPage.new(site, site.source, File.join(dir, category), category)
end

# becomes this for block with an embeded gsub
site.tags.keys.each do |tag|
  tag_name = tag.gsub(/\s+/, '-')
  site.pages << TagPage.new(site, site.source, File.join(dir, tag_name), tag)
end
{% endhighlight %}

With those two changes, I'm able to successfully generate a series of tag directories containing posts. To populate the posts for each tag directory, I can use a simple html layout with some Liquid loop tags.

{% highlight html %}
{% raw %}
{% for post in site.tags.[page.filter_tag] %}
{% endraw %}
{% endhighlight %}

In the end, this small and relatively simple customization allows me to create category and tag specific pages which can be accessed easily by specific URLs. I also added a hidden page parameter to help with some styling on my main blog page. The parameter is simply the category or tag name, and it gets added to the newly created page. I can then access this page parameter to easily show/hide DOM elements or DOM classes.

{% highlight ruby %}
self.data['filter_category'] = "#{category}"
{% endhighlight %}

{% highlight html linenos=table %}
{% raw %}
<div class="row" id="site-categories-all">
    <div class="col-md-12">
        <h4>Filter by Category{% if page.filter_category %} <small><a href="{{ site.blog.url }}">clear</a></small>{% endif %}</h4>
        {% for category in site.sorted_categories %}
        <a href="{{ site.blog.categories.url }}{{ category.first | slugify }}/" class="btn btn-lg {% if page.filter_category == category.first %}btn-success{% else %}btn-default{% endif %}" role="button">
            {{ category | first }} <span class="badge">{{ category | last | size }}</span>
        </a>
        {% endfor %}
    </div>
</div>
{% endraw %}
{% endhighlight %}

If you look at the sidebar on the page, you can hover over the tag names and see the URLs they point to.

I hope this post was helpful. I know that it took me a little while to find this solution on my own, so sharing it seemed like the least I could do for the Jekyll community.

> One caveat to this approach that is worth mentioning is that this specific plugin implementation doesn't allow for pagination of posts. If I have the time, and if I can improve my Ruby skills, I might look to enhance this generator to also support pagination.

---

## Complete code samples

#### _plugins/tagpagegenerator.rb

{% highlight ruby linenos=table %}
module Jekyll

  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), site.config['blog']['tags']['layout'])
      self.data['tag'] = tag

      tag_title_prefix = site.config['blog']['tags']['title_prefix'] || 'blog - tag: '
      self.data['title'] = "#{tag_title_prefix}#{tag}"
      self.data['filter_tag'] = "#{tag}"
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag'
        dir = site.config['blog']['tags']['url'] || 'blog/tags/'
        site.tags.keys.each do |tag|
          tag_name = tag.gsub(/\s+/, '-')
          site.pages << TagPage.new(site, site.source, File.join(dir, tag_name), tag)
        end
      end
    end
  end

end
{% endhighlight %}

#### _layouts/tag.html

{% highlight html linenos=table %}
{% raw %}
---
layout: base
---
<div class="container">
    <div class="row">
        <!-- Begin blog articles -->
        <section class="col-md-7">
            {% if site.tags.[page.filter_tag] %}
            {% for post in site.tags.[page.filter_tag] %}

            <!-- Begin post -->
            {% include blog/blog_post.html %}
            <!-- End post -->

            {% unless forloop.last %}<hr>{% endunless %}
            {% endfor %}
            {% else %}
            <h2>No posts to display.</h2>
            {% endif %}
        </section>
        <!-- End blog articles -->
    </div>
</div>
{% endraw %}
{% endhighlight %}

[generators]: http://jekyllrb.com/docs/plugins/#generators
[permalink]: http://jekyllrb.com/docs/permalinks/
[postend]: #toc_4