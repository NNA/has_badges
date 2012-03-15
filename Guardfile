# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard 'minitest', :colour => true do
  watch(%r|^spec/(.*)_spec\.rb|)
  watch(%r|^lib/(.*/)?(.*)\.rb|)       	{ |m| "spec/(.*/)?#{m[2]}_spec.rb" }
  watch(%r|^lib/generators/install/templates/model/(.*)\.rb|)        { |m| "spec/models/#{m[1]}_spec.rb" }
  watch(%r|^lib/has_badges/(.*)\.rb|)        { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r|^lib/tasks/(.*)\.rake|)        { |m| "spec/tasks/#{m[1]}.rake_spec.rb" }
  watch(%r|^spec/spec_helper\.rb|)    	{ "minitest" }
end