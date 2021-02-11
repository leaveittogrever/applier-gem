require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task default: :test

desc "Run exec"
task :run  do
  ruby "bin/job-applier-manager"
end