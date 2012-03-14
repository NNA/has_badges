# Has badges - Badges and Achievements for Rails
By using your site / service, users wins or looses points. He also achieves milestones.
You define badges that he can win at a certain level of point / milestone.
Badges are awarded automatically to the user in exchange of his points / milestones.

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

3 - Decorate user model:
``` ruby
class User < ActiveRecord::Base
  has_badges
end
```

## How To:

### Points
You can give / remove points to a resource:
``` ruby
@user.wins 70
@user.wins 70, 'Helping a friend'   # reason is facultative
@user.looses 70, 'Spamming 3 users' # reason is facultative
```

### Milestones 
You can also reward a resource after reaching a certain milestone :
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

### Distribute badges - WIP
Badge distribution takes user's points / milestone in exchange of the badge. It gives the user the first badge he can have given the points / milestones he has. 

You can distribute badges to users in 2 different ways:
1- Manually
``` ruby
HasBadges::Distribution.distribute_badges(@user)			# 
```
2- By running a rake task
``` ruby
rake has_badges:distribute              					# 
```

If you want to give a certain badge to a user without modifying using his points / milestones use this:
``` ruby
@user.award 'Best buyer'     					# Give @user the best buyer badge without modyfing his point / milestone won
@user.unaward 'Best buyer'						# Take @user 'Best buyer' badge without touching his points / milestones
```


## TODO
 - Improve perf of User DryFactories (lightweight model ?)
 - Badge awarding with rake task (WIP)
 - Test avoid usage of schema.rb reuse migration instead
 - Test: refactor DryFactory.only_for_this_test to avoid returning values to clean from within the block
 - Badge awarding Sync using after_save on UserPoints
 - Badge awarding Asynchronously using resque 
 - Better testing of validate presence of
 - Test: Refactor DryFactories
 - Release v0.1 of gem to RubyForge
 - Add a cache column to avoid querying database to know one's user badges
 - Skip model, migrations, etc... in generators
 - Make an engine

 [examples]: https://github.com/NNA/cucumber-snapshot/tree/master/examples