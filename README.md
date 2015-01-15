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

An Android device running 2.3 or newer and an API key as per [GCM getting started guide](http://developer.android.com/google/gcm/gs.html).

One of the following, tested Ruby versions:

* `1.9.3`
* `2.0.0`
* `2.1.5`
* `2.2.0`

##Usage

For your server to send a message to one or more devices, you must first initialise a new `GCM` class with your [api key](https://developer.android.com/google/gcm/gs.html#access-key), and then call the `send` method on this and give it 1 or more (up to 1000) registration IDs as an array of strings. You can also optionally send further [HTTP message parameters](http://developer.android.com/google/gcm/server.html#params) like `data` or `time_to_live` etc. as a hash via the second optional argument to `send`.

Example sending notifications:

```ruby
require 'gcm'

gcm = GCM.new("my_api_key")
# you can set option parameters in here
#  - all options are pass to HTTParty method arguments
#  - ref: https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L40-L68
#  gcm = GCM.new("my_api_key", timeout: 3)

registration_ids= ["12", "13"] # an array of one or more client registration IDs
options = {data: {score: "123"}, collapse_key: "updated_score"}
response = gcm.send(registration_ids, options)
```

Currently `response` is just a hash containing the response `body`, `headers` and `status`. Check [here](http://developer.android.com/google/gcm/http.html#response) to see how to interpret the responses.

## User Notifications

With [user notifications](http://developer.android.com/google/gcm/notifications.html), you can send a single message to multiple instance of an app running on devices owned by a single user. To use this feature, you will first need an initialised `GCM` class.

### Generate a Notification Key
Then you will need a notification key which you can create for a particular `key_name` which needs to be uniquely named per app in case you have multiple apps for the same `project_id`.  This ensures that notifications only go to the intended target app. The `create` method will do this and return the token `notification_key` in the response:

```ruby
response = gcm.create(key_name: "appUser-Chris",
                project_id: "my_project_id",
                registration_ids:["4", "8", "15", "16", "23", "42"])
```

### Send to Notification Key
Now you can send a message to a particular `notification_key` via the `send_with_notification_key` method. This allows the server to send a single data to multiple app instances  (typically on multiple devices) owned by a single user (instead of sending to registration IDs). Note: the maximum number of members allowed for a `notification_key` is 10.

```ruby
response = gcm.send_with_notification_key("notification_key", {
            data: {score: "3x1"},
            collapse_key: "updated_score"})
```

### Add/Remove Registration IDs

You can also add/remove registration IDs to/from a particular `notification_key` of some `project_id`. For example:

```ruby
response = gcm.add(key_name: "appUser-Chris",
                project_id: "my_project_id",
                notification_key:"appUser-Chris-key",
                registration_ids:["7", "3"])

response = gcm.remove(key_name: "appUser-Chris",
                project_id: "my_project_id",
                notification_key:"appUser-Chris-key",
                registration_ids:["8", "15"])
```

## Blog Posts

* [How to send iOS and Android notifications from your Rails backend](http://juretriglav.si/how-to-send-ios-and-android-notifications-from-your-rails-backend/)
* [Как отправлять push уведомления из Вашего Rails приложения](http://habrahabr.ru/post/214607/)
* [GCM – 서버 만들기](http://susemi99.kr/1023)
* [ruby から gcm を使って android 端末へメッセージを送信する](http://qiita.com/ma2saka/items/5852308b7c2855eef552)
* [titanium alloy android push通知 by ruby](http://shoprev.hatenablog.com/entry/2014/08/30/202531)

## Android Client

You can find a guide to implement an Android Client app to receive notifications here: [Implementing GCM Client](https://developer.android.com/google/gcm/client.html).

## ChangeLog

### 0.1.0
* Added `send_with_notification_key` to send message to a notification key since the documented API for it is [wrong]( http://stackoverflow.com/questions/19720767/gcm-user-notifications-missing-registration-ids-field/25183892#25183892).

### 0.0.9
* Check for [NotRegistered](http://developer.android.com/google/gcm/adv.html#unreg) error and return unregistered ids if this occurs

### 0.0.8
* Added support for User Notifications API
* Added alias method `send` for `send_notification`

### 0.0.7
* All responses now have a body and header hashes

### 0.0.6
* You can initialise GCM class with [HTTParty Options](https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L41-L69)

### 0.0.5
* Added support for [canonical registration ID](http://developer.android.com/google/gcm/adv.html#canonical)
* Only support Ruby versions [>= 1.9.3](https://www.ruby-lang.org/en/news/2014/01/10/ruby-1-9-3-will-end-on-2015/)
* Fixed Rspec deprecation warnings for Rspec 3.0.0.beta

##MIT License

* Copyright (c) 2015 Kashif Rasul and Shoaib Burq. See LICENSE.txt for details.

##Many thanks to all the contributors

* [Contributors](https://github.com/spacialdb/gcm/contributors)

## Donations
We accept tips through [Gratipay](https://gratipay.com/spacialdb/).

[![Gratipay](https://img.shields.io/gratipay/spacialdb.svg)](https://www.gittip.com/spacialdb/)
