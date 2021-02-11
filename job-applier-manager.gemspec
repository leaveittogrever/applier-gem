Gem::Specification.new do |spec|
  spec.name        = 'job-applier-manager'
  spec.version     = '0.0.0'
  spec.summary     = "A job applier manager"
  spec.description = "A reporting suite for job applications."
  spec.authors     = ["Paul Grever"]
  spec.email       = '[paulgrever@gmail.com]'
  spec.files       = [
  "lib/job-applier-manager.rb",
   "lib/models/job.rb",
   "lib/models/applicant.rb",
   "lib/models/job_applicant.rb",
   "lib/database/database.rb"]
  spec.homepage    =
    'https://rubygems.org/gems/job-applier-manager'
  spec.license       = 'MIT'
  spec.executables << 'job-applier-manager'
  spec.bindir = 'bin'
  spec.add_dependency 'pg', '~> 1.0'
  spec.add_dependency 'minitest', '~> 5.8'

  spec.post_install_message = "Thanks for installing!"
end