
if defined? RSpec # otherwise fails on non-live environments  
  task(:spec).clear  
  desc "Run all specs and all the integration tests"  
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './{spec,integration}/**/*_spec.rb'
  end

  namespace :spec do
    desc "Run the integration tests that hit Apple's Services"
    RSpec::Core::RakeTask.new(:integration) do |t| 
      t.pattern = './integration/**/*_spec.rb'
    end

    desc "Run the specs that used mocked responses"
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.pattern = './spec/**/*_spec.rb'
    end
  end
end