# Google Cloud Messaging for Android (GCM)
[![Build Status](https://secure.travis-ci.org/spacialdb/gcm.png?branch=master)](http://travis-ci.org/spacialdb/gcm)

GCM sends notifications to Android devices via [GCM](http://developer.android.com/guide/google/gcm/gcm.html).

##Installation

    $ gem install gcm

##Requirements

An Android device running 2.0 or newer and an API key as per [GCM getting started guide](http://developer.android.com/guide/google/gcm/gs.html).

One of the following, tested Ruby versions:

* `1.9.3`
* `2.0.0`
* `2.1.0`

##Usage

Sending notifications:

```ruby
require 'gcm'

gcm = GCM.new(api_key)
registration_ids= ["12", "13"] # an array of one or more client registration IDs
options = {data: {score: "123"}, collapse_key: "updated_score"}
response = gcm.send_notification(registration_ids, options)
```

Currently `response` is just a hash containing the response `body`, `headers` and `status`.

If the above code is stored in a file like `trigger_gcm.rb`, thats how you can call it.

	$ ruby -rubygems trigger_gcm.rb

## Blog posts

* [How to send iOS and Android notifications from your Rails backend](http://blog.wellwith.me/how-to-send-ios-and-android-notifications-from-your-rails-backend)

## ChangeLog

### Version 0.0.5

* Added support for canonical registration ID
* Only support Ruby versions [>= 1.9.3](https://www.ruby-lang.org/en/news/2014/01/10/ruby-1-9-3-will-end-on-2015/)
* Fixed Rspec deprecation warnings for Rspec 3.0.0.beta

##MIT License

* Copyright (c) 2012 Kashif Rasul and Shoaib Burq. See LICENSE.txt for details.

##Many thanks to all the contributors

* [Contributors](https://github.com/spacialdb/gcm/contributors)
