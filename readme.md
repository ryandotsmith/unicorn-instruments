# unicorn-instruments

This is a hack in order to account for the total time spent in ruby while processing http requests.

## Usage

```ruby
gem 'unicorn-instruments'
```

Require the gem in your unincorn config file.

config/unicorn.rb

```ruby
require 'unicorn-instruments'
...
```

## Synopsis

```
Start a timer.
Call accept().
Call send().
Close socket.
Stop timer.
Print Elapsed time.
```


If the timer elapsed for 4ms, the following log line will be printed:

```
measure=unicorn.process val=4
```

Using this data with [l2met](https://github.com/ryandotsmith/l2met) you can plot the unicorn processing time with the router service time. The difference between the values will be the time spent in the Heroku network.

![img](http://f.cl.ly/items/0W3Y181W413O2o1a1t3Y/unicorn-instruments.png)
