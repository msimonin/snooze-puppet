# Rakefile for dependency management
# Reference : openstack module dependency management

begin
  require 'yaml'
  require 'fileutils'
  rescue LoadError
    puts "Load Error"
end


dependencies_file = 'dependencies.yaml'
default_modulepath = 'modules'

namespace :modules do
  desc 'clone all dependend modules'
  task :clone do
   repo_hash = YAML.load_file(File.join(File.dirname(__FILE__), dependencies_file))
   repos = (repo_hash['repos'] || {})
   modulepath = (repo_hash['modulepath'] || default_modulepath)
   repos_to_clone = (repos['repo_paths'] || {})
   to_checkout = (repos['to_checkout'] || {})
   repos_to_clone.each do |remote, local|
     # I should check to see if the file is there?
     outpath = File.join(modulepath, local)
     output = `git clone #{remote} #{outpath}`
     puts output
   end
   to_checkout.each do |local, checkout|
     Dir.chdir(File.join(modulepath, local)) do
       output = `git checkout #{checkout}`
       puts output
     end
   end
  end

  desc 'clean cloned modules'
  task :clean do
     repo_hash = YAML.load_file(File.join(File.dirname(__FILE__), dependencies_file))
     repos = (repo_hash['repos'] || {})
     modulepath = (repo_hash['modulepath'] || default_modulepath)
     repos_to_clone = (repos['repo_paths'] || {})
     repos_to_clone.each do |remote, local|
       output = FileUtils.rm_rf File.join(modulepath, local)
       puts output
     end
  end
end
