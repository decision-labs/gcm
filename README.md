# Google Cloud Messaging for Android (GCM)
[![Build Status](https://secure.travis-ci.org/spacialdb/gcm.png?branch=master)](http://travis-ci.org/spacialdb/gcm)

GCM sends notifications to Android devices via [GCM](http://developer.android.com/guide/google/gcm/gcm.html).

##Installation

    $ gem install gcm

or in your `Gemfile` just include it:

```ruby
gem 'gcm'
```

##Requirements

An Android device running 2.2 or newer and an API key as per [GCM getting started guide](http://developer.android.com/google/gcm/gs.html).

One of the following, tested Ruby versions:

* `1.9.3`
* `2.0.0`
* `2.1.0`

##Usage

For your server to send a message to one or more devices, you must first initialize a new `GCM` class with your api key, and then call the `send_notification` method on this and give it 1 or more (up to 1000) registration IDs as an array of strings. You can also optionally send further [HTTP message parameters](http://developer.android.com/google/gcm/server.html#params) like `data` or `time_to_live` etc. as a hash via the second optional argument to `send_notification`.

Example sending notifications:

```ruby
require 'gcm'

gcm = GCM.new(api_key)
# you can set option parameters in here
#  - all options are pass to HTTParty method arguments
#  - ref: https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L40-L68
#  gcm = GCM.new(api_key, timeout: 3)

registration_ids= ["12", "13"] # an array of one or more client registration IDs
options = {data: {score: "123"}, collapse_key: "updated_score"}
response = gcm.send_notification(registration_ids, options)
```

Currently `response` is just a hash containing the response `body`, `headers` and `status`. Check [here](http://developer.android.com/google/gcm/http.html#response) to see how to interpret the responses.

## Blog posts

* [How to send iOS and Android notifications from your Rails backend](http://blog.wellwith.me/how-to-send-ios-and-android-notifications-from-your-rails-backend)

## ChangeLog

## 0.0.7
* All responses now have a body and header hashes

### 0.0.6

* You can initialize GCM class with [HTTParty Options](https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L40-L68)

### 0.0.5

* Added support for [canonical registration ID](http://developer.android.com/google/gcm/adv.html#canonical)
* Only support Ruby versions [>= 1.9.3](https://www.ruby-lang.org/en/news/2014/01/10/ruby-1-9-3-will-end-on-2015/)
* Fixed Rspec deprecation warnings for Rspec 3.0.0.beta

##MIT License

* Copyright (c) 2014 Kashif Rasul and Shoaib Burq. See LICENSE.txt for details.

##Many thanks to all the contributors

* [Contributors](https://github.com/spacialdb/gcm/contributors)
