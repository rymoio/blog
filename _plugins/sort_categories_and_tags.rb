module Jekyll

  class SortedCategoriesBuilder < Generator
    ##
    # Sorts your list of categories using the
    # number of posts as the sort parameter.

    safe true
    priority :high

    def generate(site)
      site.config['sorted_categories'] = site.categories.map { |category, posts|
        [ category, posts.size, posts ] }.sort { |a,b| b[1] <=> a[1] }
    end
  end

  class SortedTagsBuilder < Generator
    ##
    # Sorts your list of tags using the
    # number of posts as the sort parameter.

    safe true
    priority :high

    def generate(site)
      site.config['sorted_tags'] = site.tags.map { |tag, posts|
        [ tag, posts.size, posts ] }.sort { |a,b| b[1] <=> a[1] }
    end
  end

end