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

### Know user's badges
``` ruby
@user.badges #returns an array of badges
@user.has_badge? 'Serial Killer' # true or false
```

### Increase number of points of a user (to be done...)
You can add points to given resource using :
``` ruby
  @user.earns 70
  @user.earns 70, euros
```
by default points currency is used

## TODO
 - Add points_log & earns method to has_badges extension
 - Define achievements (model, generators)
 - Trigger badge awarding when user complete achievement
 - Test: Refactor avoid duplication of model definition in fixture
 - Test: Refactor before each code as SpecHelper method
 - Release v0.0.1 of gem to RubyForge
 - Add a cache column to avoid querying database to know one's user badges
 - Skip model, migrations, etc... in generators
 - Make an engine

 [examples]: https://github.com/NNA/cucumber-snapshot/tree/master/examples