---
layout: post
title: RenderIt gem
tags:
- renderit
- gem
- html5
- css3
---

At the moment browsers are moving forward to [html5](http://www.html5rocks.com/)/[css3](http://www.css3.info/preview/). But it will take time for users to use html5/css3 browsers only. At the moment about 60% of users are using Internet Explorer (stable version of IE doesn't support html5/css3).
This problem forces developers to forget about new features brought by new browsers and develop websites same way as they did it years and years ago. Aim of RenderIt gem is to solve this problem.
<!-- Preview -->

This issue can be solved in several ways:
1. Avoid using html5/css3 features. But in this case users that are using modern browsers won't have that user expirience they could have
2. Ignore old browsers. But in this case more than 60% of internet users won't be able to use your service
3. Render most of elements on the client-side with javascript depending on browser version. We can even use GWT to fetch only javascript for our browser (not for all the other browsers also). But create and support such javascript is enough complicated task and there could be issues with search engines as most of your content will be generated with javascript after load.
4. Give users different pages depending on browser they are running. This can be accomplished by parsing `user_agent` that is send in the header when user makes request.

RenderIt gem makes last thing. You will be able to have different views and layouts for different browsers. To start using this gem you need to install it 
{% highlight bash %}
gem install renderit
{% endhighlight %}
After this you need to require this gem in your rails application. 

#### RenderIt configuration

To configure browser-specific templates, `config/renderit.yml` file has to be created. In this file you can specify template names for specific browsers in the following way
{% highlight yaml %}
template:
        new: chrome>=4, opera>=10.5, firefox>=3.5, safari>=4
        mobile: safarimobile>=3
{% endhighlight %}

In yaml file defining template name for specific browsers you can use all characters for comparing (you can skip '==' sign if you want and write ie6 instead of ie==6 ). 

After this if I will use Chrome5 and will request some page (/users/new for example) and in views folder `users/new_new.html.erb` file will be present - it will be rendered, not the default one. Same thing with layouts. If there will be no file with '_new' postfix - the default view will be rendered. 

#### Customizing browser determination

By default following regular expressions are used to determine browser name and browser version:

{% highlight ruby %}
DEFAULT_BROWSERS_CONFIG = {
    'ie' => 'msie (\d+\.\d).*\)(?!\s*opera)', 
    'firefox' => 'gecko.*?firefox\/(\d+\.\d)', 
    'chrome' => 'applewebkit.*?chrome\/(\d+\.\d)', 
    'safari' => 'applewebkit.*?version\/(\d+.\d)(?![.\d\s]*mobile)',    
    'safarimobile' => 'applewebkit.*?version\/(\d+.\d)[.\d\s]*mobile.*?safari', 
    'opera' => 'opera.*?version\/(\d+\.\d)' 
  }
{% endhighlight %}

In this hash keys are browser names and values are regular expressions that are used to determine browser version. First value in round brackets will be considered browser version. To check work of regular expressions we can use [Rubular](http://rubular.com/) website. Following [this](http://rubular.com/r/YUuq6bN65i) link you will see regular expression for Chome (*i* on the right means that regular expression is case insensitive) and test string with `user_agent` of Chrome6 browser. As you see in 'Match captures' block, browser version is right. If you want to change regular expression for browser determination, you can add following lines to `config/renderit.yml` file

{% highlight yaml %}
browsers:
        konqueror: konqueror\/(\d+\.\d)
{% endhighlight %}

After this you will be able to create konqueror- specific templates.
{% highlight yaml %}
templates:
        konq: konqueror>3.4
{% endhighlight %}

If you think that regular expressions that are used to determine browsers are wrong - you can change them as *DEFAULT_BROWSERS_CONFIG* is merged with browsers information provided by user. If so - please let me know by creating an [issue](http://github.com/romanoff/renderit/issues).

With this gem you will be able to create different html files for different browsers. This will let you use html5/css3 if browser supports this.
