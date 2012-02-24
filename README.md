# Has badges - Badges and Achievements for Rails

The purpose of this tool is to ....

## Install:
1) Install gem

``` ruby
gem install has_badges
```

OR in your Gemfile (if using Bundler):

``` ruby
gem 'has_badges', :git=>'https://github.com/NNA/has_badges'
```

Run the generators:

``` ruby
rails g has_badges

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