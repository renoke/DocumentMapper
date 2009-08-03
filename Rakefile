require 'rake'
require 'spec/rake/spectask'
require 'key_value_mapper.rb'

task :default => ['spec:all']

namespace "spec" do

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
    t.spec_files = FileList['spec/integration/*']
  end
  
  desc "run all spec"
  task :all => [:adapters, :validatable, :core, :integration]
  
  desc "run all spec with rcov"
  Spec::Rake::SpecTask.new("rcov") do |t|
    t.spec_files = FileList['spec/unit/core/*', 'spec/unit/adapters/*', 
                            'spec/unit/validatable/*', 'spec/unit/integration/*']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec,/Library,/Users']
  end
  
end



