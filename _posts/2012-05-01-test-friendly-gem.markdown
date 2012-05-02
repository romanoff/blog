---
layout: post
title: Test friendly gem
tags:
- tests
- validations
- callbacks
- gem
---

 Validations in rails are easy to use. Even if some custom validations have to be created, there is generic way to do it and create [custom validators](http://guides.rubyonrails.org/active_record_validations_callbacks.html#performing-custom-validations). The problems might appear when model instances have to be tested. Even though unit tests usually cover behavior of an instances, not validations, they are still executed in every test. Usually not to create valid objects evey time by hand, people use fixtures or factories. This way people don't have to think about validations and tests are close to real environment (although probably validations don't have to be tested at all or only custom ones). But the real problems appear when in order to create one valid object, lots of other objects have to be created first. This is fine if we check interconnections between those objects. But if not ... setup becomes pretty painful.
<!-- Preview -->
Test friendly gem aims to solve this problem. Installation is as easy as

{% highlight bash %}
gem install test_friendly
{% endhighlight %}

Here is an example of model using it:

{% highlight ruby %}
  # Fields present in model:
  # first_name, last_name
  class User < ActiveRecord::Base
    acts_as_test_friendly
  
    test_friendly_validations do
      validates_presence_of :first_name, :last_name
    end
  
  end
{% endhighlight %}

Defining validations in `test_friendly_validations` block makes validations work in **development** and **production** environments, but turned off in **test** environment. Validations will have to be turned on manually in tests. To turn **User** validations on, `User.force_validations` method has to be used.

By default validations will be dropped before every rspec test. But other in other testing frameworks `User.drop_validations` method will have to be used. This way validations can be turned off.

You also might want to test different validations in different tests. In this case you might want to turn on only specific one. Luckily test friendly gem provides this functionality as well. Here is an example:

{% highlight ruby %}
  # Fields present in model:
  # first_name, last_name, new_attribute, default_field
  class User < ActiveRecord::Base
    acts_as_test_friendly

    test_friendly_validations do
      validates_presence_of :default_field
    end
  
    test_friendly_validations(:basic) do
      validates_presence_of :first_name, :last_name
    end

    test_friendly_validations(:additional) do
      validates_presence_of :new_attribute
    end
  
  end
{% endhighlight %}

In order to turn on only basic validations, we will have to use `User.force_validations(:basic)` method. Same way we will be able to force **additional** validations. If tag name is not specified, then you will still be able to turn on those validations by calling `User.force_validations`. No other validations will be forced in this case. But there is a way to do this. To turn on all test friendly validations that appear in blocks (no matter what tag name is), you can just use `User.force_validations(:all)` method. All same method signatures work for dropping validations.

Enough with validations. Let's now speak about callbacks. They can be same way painful. Test friendly gem turns them off during testing as well (with an ability to turn on as you need them).

{% highlight ruby %}
  # Fields present in model:
  # first_name, last_name
  class User < ActiveRecord::Base
    include NotificationEmailSender
    acts_as_test_friendly
  
    test_friendly_callbacks do
      after_create :send_notification_email
    end
  
  end
{% endhighlight %}

This way when user is created, notification emails won't be sent in test environment. But if you want to test some callback specifically, `User.force_callbacks` should help you. Generally speaking callbacks and validations work the same way and both are capable of using tags and be turned on/off during tests.

If you decided to turn on/off validations or callbacks all around the project in certain tests, you can benefit from `TestFriendly::Global.force_validations`, `TestFriendly::Global.drop_validations`, `TestFriendly::Global.force_callbacks`, `TestFriendly::Global.drop_callbacks` methods. They works with tags as well. 

Any comments or problems with gem - please post on [github](https://github.com/romanoff/test_friendly)
