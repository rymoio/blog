module Jekyll

  module ReadingTimeFilter
    ##
    # Outputs the reading time
    # Read this in “# minute(s)” or "< 1 minute"
    # Put into your _plugins dir in your Jekyll site
    # Usage: Read content in about {{ page.content | reading_time }}

    def reading_time(input)
      wpm = 180  # average wpm for monitor reading
      words = input.split.size;
      minutes = (words / wpm).floor
      label = minutes === 1 ? " minute" : " minutes"
      minutes > 0 ? "#{minutes} #{label}" : "< 1 minute"
    end

  end

end

Liquid::Template.register_filter(Jekyll::ReadingTimeFilter)