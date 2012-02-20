# Level up - Upgrade 

The purpose of this tool is to ....

## Install:
1) Install gem

``` ruby
gem install level_up
```

OR in your Gemfile (if using Bundler):

``` ruby
gem 'level_up', :git=>'https://github.com/NNA/level_up'
```

Run the generators:

``` ruby
rails g level_up

## How To:

### Increase / Decrease number of points of a user
You can add points to given resource using :
``` ruby
  @user.earn 70
  @user.earn 70, euros
```
by default points currency is used

### Know user's badges
``` ruby
@user.badges #returns an array of badges
@user.has_badge? 'lord of rings' # true or false
```

### Know user's badge activity



## TODO
 - Skip model, migrations, etc... in generators
 - Make an engine

 [examples]: https://github.com/NNA/cucumber-snapshot/tree/master/examples