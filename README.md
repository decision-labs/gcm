# Google Cloud Messaging for Android (GCM)
[![Build Status](https://secure.travis-ci.org/shamithc/gcm.png?branch=master)](http://travis-ci.org/shamithc/gcm)

GCM sends notifications to Android devices via [GCM](http://developer.android.com/guide/google/gcm/gcm.html).

##Installation

    $ gem install gcm

##Requirements

An Android device running 2.0 or newer and an API key as per [GCM getting started guide](http://developer.android.com/guide/google/gcm/gs.html).

One of the following, tested ruby version:

* `1.8.7`
* `1.9.x`
* `2.0.0`

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

##MIT License

* Copyright (c) 2012 Kashif Rasul and Shoaib Burq. See LICENSE.txt for details.

##Thanks

This gem is based on a fork of the older Google push service:

* [Amro Mousa](https://github.com/amro/c2dm/)
