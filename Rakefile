# Found at: http://gist.github.com/143571
desc 'Generate tags'
namespace :tags do
  task :generate do
    puts 'Generating tags...'
    require 'rubygems'
    require 'jekyll'
    include Jekyll::Filters
 
    options = Jekyll.configuration({})
    site = Jekyll::Site.new(options)
    site.read_posts('')
 
    html =<<-HTML
---
layout: tags
title: Tags
---
    HTML
 
    # Sort by the number of posts in tag.
    tags = site.tags.sort_by { |s| s[1].length }

    tags.reverse.each do |tag, posts|
      html << <<-HTML
      <h3 id="#{tag}"><span class="cursor">&rarr;</span> <span class="tag">#{tag}</span> (#{posts.length})</h3>
      HTML
 
      html << '<ul class="posts">'
      posts.reverse.each do |post|
        post_data = post.to_liquid
        html << <<-HTML    
          <li><span>#{date_to_string post.date}</span> &rarr; <a href="#{post.url}" class="title">#{post_data['title']}</a></li>
        HTML
      end
      html << '</ul>'
    end
 
    File.open('tags.html', 'w+') do |file|
      file.puts html
    end
 
    puts 'Done.'
  end
end