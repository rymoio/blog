module Jekyll

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), site.config['categories']['layout'])
      self.data['category'] = category

      category_title_prefix = site.config['categories']['title_prefix'] || 'blog - category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
      self.data['filter_category'] = "#{category}"
    end
  end

  class CategoryPageGenerator < Generator
    ##
    # Generates pages for each category and
    # places them in a directory folder with
    # a slugified name of the category.

    safe true

    def generate(site)
      if site.layouts.key? 'category'
        dir = site.config['categories']['url'] || 'blog/categories/'
        site.categories.keys.each do |category|
          category_name = category.gsub(/\s+/, '-')
          site.pages << CategoryPage.new(site, site.source, File.join(dir, category_name), category)
        end
      end
    end
  end

  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), site.config['tags']['layout'])
      self.data['tag'] = tag

      tag_title_prefix = site.config['tags']['title_prefix'] || 'blog - tag: '
      self.data['title'] = "#{tag_title_prefix}#{tag}"
      self.data['filter_tag'] = "#{tag}"
    end
  end

  class TagPageGenerator < Generator
    ##
    # Generates pages for each tag and
    # places them in a directory folder with
    # a slugified name of the tag.

    safe true

    def generate(site)
      if site.layouts.key? 'tag'
        dir = site.config['tags']['url'] || 'blog/tags/'
        site.tags.keys.each do |tag|
          tag_name = tag.gsub(/\s+/, '-')
          site.pages << TagPage.new(site, site.source, File.join(dir, tag_name), tag)
        end
      end
    end
  end

end