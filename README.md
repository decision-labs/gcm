# Google Cloud Messaging for Android (GCM)
[![Gem Version](https://badge.fury.io/rb/gcm.svg)](http://badge.fury.io/rb/gcm) [![Build Status](https://secure.travis-ci.org/spacialdb/gcm.png?branch=master)](http://travis-ci.org/spacialdb/gcm)

GCM sends notifications to Android devices via [GCM](https://developers.google.com/cloud-messaging/gcm).

##Installation

    $ gem install gcm

or in your `Gemfile` just include it:

```ruby
gem 'gcm'
```

##Requirements

An Android device running 2.3 (or newer) or an iOS device and an API key as per [GCM getting started guide](https://developers.google.com/cloud-messaging/android/start).

One of the following, tested Ruby versions:

* `2.0.0`
* `2.1.8`
* `2.2.4`
* `2.3.0`

##Usage

For your server to send a message to one or more devices, you must first initialise a new `GCM` class with your Api key, and then call the `send` method on this and give it 1 or more (up to 1000) registration tokens as an array of strings. You can also optionally send further [HTTP message parameters](https://developers.google.com/cloud-messaging/http-server-ref) like `data` or `time_to_live` etc. as a hash via the second optional argument to `send`.

Example sending notifications:

```ruby
require 'gcm'

gcm = GCM.new("my_api_key")
# you can set option parameters in here
#  - all options are pass to HTTParty method arguments
#  - ref: https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L29-L60
#  gcm = GCM.new("my_api_key", timeout: 3)

registration_ids= ["12", "13"] # an array of one or more client registration tokens
options = {data: {score: "123"}, collapse_key: "updated_score"}
response = gcm.send(registration_ids, options)
```

Currently `response` is just a hash containing the response `body`, `headers` and `status`. Check [here](https://developers.google.com/cloud-messaging/http#response) to see how to interpret the responses.

## Device Group Messaging

With [device group messaging](https://developers.google.com/cloud-messaging/notifications), you can send a single message to multiple instance of an app running on devices belonging to a group. Typically, "group" refers a set of different devices that belong to a single user. However, a group could also represent a set of devices where the app instance functions in a highly correlated manner. To use this feature, you will first need an initialised `GCM` class.

### Generate a Notification Key for device group
Then you will need a notification key which you can create for a particular `key_name` which needs to be uniquely named per app in case you have multiple apps for the same `project_id`.  This ensures that notifications only go to the intended target app. The `create` method will do this and return the token `notification_key`, that represents the device group, in the response:

```ruby
response = gcm.create(key_name: "appUser-Chris",
                project_id: "my_project_id", # https://developers.google.com/cloud-messaging/gcm#senderid
                registration_ids:["4", "8", "15", "16", "23", "42"])
```

### Send to Notification Key
Now you can send a message to a particular `notification_key` via the `send_with_notification_key` method. This allows the server to send a single data to multiple app instances  (typically on multiple devices) owned by a single user (instead of sending to some registration tokens). Note: the maximum number of members allowed for a `notification_key` is 20.

```ruby
response = gcm.send_with_notification_key("notification_key", {
            data: {score: "3x1"},
            collapse_key: "updated_score"})
```

### Add/Remove Registration Tokens

You can also add/remove registration Tokens to/from a particular `notification_key` of some `project_id`. For example:

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

## Send Messages to Topics

GCM topic messaging allows your app server to send a message to multiple devices that have opted in to a particular topic. Based on the publish/subscribe model, topic messaging supports unlimited subscriptions per app. Sending to a topic is very similar to sending to an individual device or to a user group, in the sense that you can use the `gcm.send_with_notification_key()` method where the `noticiation_key` matches the regular expression `"/topics/[a-zA-Z0-9-_.~%]+"`:

```ruby
response = gcm.send_with_notification_key("/topics/yourTopic", {
            data: {message: "This is a GCM Topic Message!"})
```

Or you can use the helper:

```ruby
response = gcm.send_to_topic("yourTopic", {
            data: {message: "This is a GCM Topic Message!"})
```

## Blog Posts

* [How to send iOS and Android notifications from your Rails backend](http://juretriglav.si/how-to-send-ios-and-android-notifications-from-your-rails-backend/)
* [Как отправлять push уведомления из Вашего Rails приложения](http://habrahabr.ru/post/214607/)
* [GCM – 서버 만들기](http://susemi99.kr/1023)
* [ruby から gcm を使って android 端末へメッセージを送信する](http://qiita.com/ma2saka/items/5852308b7c2855eef552)
* [titanium alloy android push通知 by ruby](http://shoprev.hatenablog.com/entry/2014/08/30/202531)
* [Android Push Notifications via Rails](http://azukiweb.com/blog/2015/android-push-nots/)

## Mobile Clients

You can find a guide to implement an Android Client app to receive notifications here: [Set up a GCM Client App on Android](https://developers.google.com/cloud-messaging/android/client).

The guide to set up an iOS app to get notifications is here: [Setting up a GCM Client App on iOS](https://developers.google.com/cloud-messaging/ios/client).

## ChangeLog

### 0.1.1

* Added helper `send_to_topic` to send messages to [topics](https://developers.google.com/cloud-messaging/topic-messaging).
* Fixed documentation and updated base uri to `https://gcm-http.googleapis.com/gcm`

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

* Copyright (c) 2016 Kashif Rasul and Shoaib Burq. See LICENSE.txt for details.

##Many thanks to all the contributors

* [Contributors](https://github.com/spacialdb/gcm/contributors)

## Donations
We accept tips through [Gratipay](https://gratipay.com/spacialdb/).

[![Gratipay](https://img.shields.io/gratipay/spacialdb.svg)](https://www.gittip.com/spacialdb/)
