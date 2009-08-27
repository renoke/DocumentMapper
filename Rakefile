require 'rake'
require 'lib/documentmapper.rb'

task :default => ['spec:all']

namespace "spec" do
begin
  require 'spec/rake/spectask'
  desc "run adapters spec"
  Spec::Rake::SpecTask.new("adapters") do |t|
    t.spec_files = FileList['spec/unit/adapters/*']
  end

  desc "run validatable spec"
  Spec::Rake::SpecTask.new("validatable") do |t|
    t.spec_files = FileList['spec/unit/validatable/*']
  end

  desc "run core spec"
  Spec::Rake::SpecTask.new("core") do |t|
    t.spec_files = FileList['spec/unit/core/*']
  end
  
  desc "run integration spec"
  Spec::Rake::SpecTask.new("integration") do |t|
    t.spec_files = FileList['spec/integration/*_spec.rb']
  end
  
  desc "run all spec"
  task :all => [:adapters, :validatable, :core, :integration]
rescue LoadError
  task :error do
    abort "Rspec is not available"
  end  
end
end

namespace "rcov" do
  
  desc "analyses rspec coverage"
  Spec::Rake::SpecTask.new("all") do |t|
    t.spec_files = FileList['spec/unit/core/*', 'spec/unit/adapters/*', 
                            'spec/unit/validatable/*', 'spec/unit/integration/*']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec,/Library,/Users']
  end
  
end


namespace "flog" do
  
  desc "analyses code complexity of all project"
  task :all do
    sh 'find "lib/" -name \\*.rb|xargs flog'
  end
  
  desc "analyse code complexity of specific project files"
  task :specific do
    sh "find lib/adapters/ lib/core/ lib/extensions/ -name \\*.rb|xargs flog"
  end
  
end

desc "analyzes code for structural similarities"
task :flay do
  sh 'flay lib/**/*.rb'
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "documentmapper"
    gemspec.rubyforge_project = 'documentmapper'
    gemspec.summary     = "a mapper for document oriented database"
    gemspec.email       = "renaud.kern@gmail.com"
    gemspec.homepage    = "http://github.com/renoke/DocumentMapper/"
    gemspec.authors     = ["Renaud Kern (renoke)"]

    gemspec.has_rdoc    = false
    gemspec.add_dependency('couchrest', '>=0.32')
    gemspec.add_dependency('mongodb-mongo', '>=0.6.5')
    gemspec.add_dependency('activesupport')
  end
  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end


