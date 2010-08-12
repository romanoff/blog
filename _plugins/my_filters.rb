module Jekyll
  module Filters
    def short_month(date)
      date.strftime("%b").upcase
    end

    def day(date)
      date.strftime("%d")
    end

    def preview(input)      
      input.split('<!-- Preview -->')[0]
    end

    def page_url(page)
      return '#' unless page
      return '/' if page == 1
      return "/page#{page}"
    end

    def nav_link_class(page)
      return 'no_follow' unless page
      ''
    end

    def post_url(url)
      return '#' unless url
      return url if url
    end

    

  end
end
