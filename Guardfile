# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard 'minitest', :colour => true do
  watch(%r|^spec/(.*)_spec\.rb|)
  watch(%r|^lib/(.*/)?(.*)\.rb|)       { |m| "spec/#{m[2]}_spec.rb" }
  watch(%r|^spec/spec_helper\.rb|)    { "minitest" }
end