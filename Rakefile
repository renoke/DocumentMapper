require 'rake'
require 'spec/rake/spectask'
require './lib/document.rb'

task :default => ['spec:all']

namespace "spec" do

  desc "run adapters spec"
  Spec::Rake::SpecTask.new("adapters") do |t|
    t.spec_files = FileList['spec/unit/adapters/*']
  end

  desc "run validatable spec"
  Spec::Rake::SpecTask.new("validatable") do |t|
    t.spec_files = FileList['spec/unit/adapters/*']
  end

  desc "run main files spec"
  Spec::Rake::SpecTask.new("main") do |t|
    t.spec_files = FileList['spec/unit/config_spec.rb', 'spec/unit/core_mash_spec.rb', 'spec/unit/crud_spec.rb']
  end
  
  desc "run integration spec"
  Spec::Rake::SpecTask.new("integration") do |t|
    t.spec_files = FileList['spec/integration/*']
  end
  
  desc "run all spec"
  task :all do
    puts 'Running adapters spec'
    Rake::Task["spec:adapters"].execute
    puts 'Running validatable spec'
    Rake::Task["spec:validatable"].execute
    puts 'Running main file spec'
    Rake::Task["spec:main"].execute
    puts 'Running integration spec'
    Rake::Task["spec:integration"].execute
  end

end



