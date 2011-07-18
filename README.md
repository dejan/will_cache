WillCache
=========

WillCache provides simple API for caching ActiveRecord objects that uses ActiveSupport Cache Store internally so that it's trivial to switch cache storage. WillCache API is heavily inspired by excellent but no longer maintained [cache_fu plugin](https://github.com/defunkt/cache_fu) and one of the goals of the gem is to provide drop-in replacement for it.


## Example usage

    >> User.last.cached(:profile)
      User Load (0.000581) (1 Row)   SELECT * FROM `users` ORDER BY users.id DESC LIMIT 1
      Cache miss: User:65:profile
      Profile Load (0.000454) (1 Row)   SELECT * FROM `profiles` WHERE (`profiles`.user_id = 65) LIMIT 1
      Cache write (will save 1.64ms): User:65:profile
    => #<Profile id: 65, first_name: nil, last_name: nil, ...>

Example shows [inline log in Rails console](http://rors.org/2011/07/17/inline-logging-in-rails-console.html). 


## Install

Specify the gem in Gemfile of the project

    gem "will_cache"


## Credits

Author: [Dejan Simic](http://github.com/dejan)<br/>

Initial development of the gem was sponsored by [LessEverything](http://lesseverything.com)