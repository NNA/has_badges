# Has badges - Badges and Achievements for Rails

WARNING: This gem is still much work in progress and is not production ready.

## Install:
1 - Install gem

``` ruby
gem install has_badges
```

OR in your Gemfile (if using Bundler):

``` ruby
gem 'has_badges', :git=>'https://github.com/NNA/has_badges'
```

2 - Run the generators:

``` ruby
rails g has_badges
```
## How To:

### Give points
You can reward a given resource with points:
``` ruby
@user.wins 70
@user.wins 70, 'Helping a friend'   # reason is facultative
```

You can also remove points :
``` ruby
@user.looses 70, 'Spamming 3 users' # reason is facultative
```

### Achieve milestones 
You can also reward a resource after reaching a milestone :
``` ruby
@user.achieved 'Registration'     	# set user registration milestone
```
by doing this the number of points defined for this milestone are added to user's point_logs.

### Know user's badges & achievements
``` ruby
@user.badges 							# returns an array of badges
@user.has_badge? 'Serial Killer' 		# true or false
@user.achievements                  	# a list of user achivements
@user.achieved? :registration       	# true if user achieved the 'Registration' achievement 
```

## TODO
 - Define achievements (model, generators)
 - Trigger badge awarding when user complete achievement
 - Test: Refactor before each code as SpecHelper method
 - Release v0.0.1 of gem to RubyForge
 - Add a cache column to avoid querying database to know one's user badges
 - Skip model, migrations, etc... in generators
 - Make an engine

 [examples]: https://github.com/NNA/cucumber-snapshot/tree/master/examples