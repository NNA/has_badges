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

### Increase number of points of a user
You can add points to given resource using :
``` ruby
  @user.earns 70
  @user.earns 70, euros
```
by default points currency is used

### Know user's badges
``` ruby
@user.badges #returns an array of badges
@user.has_badge? 'Serial Killer' # true or false
```

### Know user's badge activity



## TODO
 - Add a cache column to avoid querying database to know one's user badges
 - Skip model, migrations, etc... in generators
 - Make an engine

 [examples]: https://github.com/NNA/cucumber-snapshot/tree/master/examples