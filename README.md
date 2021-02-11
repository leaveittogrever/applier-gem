# Job Applier Manager Gem

Background, this is a Ruby gem that does not rely on rails but does require Postgres and uses the PG Gem.
It was inspired by Devise in that you can install this gem and then it will auto generate the neccessary tables, and models to have a working job application manager.
It uses raw SQL to create a `Jobs` table, an `Applicants` table and a `JobApplicants` table. We then built a relational system to insert and query these tables. 

The database has some nice reporting features built in for receving results as applicant, as well as a high level for Employers to view application rates and applicant reports.

This gem is currently unpublished, as it would need some polish work on more DB methods as well as some security in sanitizing and preventing some SQL injections.

## Installation

Build the gem locally:
```shell script
gem build job-applier-manager.gemspec
```

Install the gem locally:

```shell script
gem install ./job-applier-manager-0.0.0.gem
```

To run the sample script with some test jobs and applicants with reporting overview: 

```shell script
rake run 

or 

ruby bin/job-applier-manager
```

To run test: 

```shell script
rake test
```


## Dependencys

```
  spec.add_dependency 'pg', '~> 1.0'
  spec.add_dependency 'minitest', '~> 5.8'
```

### Sample script in execuatble file

```ruby
require 'job-applier-manager'

JobApplierManager.create_database

job = Job.new(name: "Avengers", company_name: "Marvel", number_of_positions: 2)
job.save

first_applicant = Applicant.new(first_name: "Incredible", last_name: "Hulk")
first_applicant.save

first_applicant.apply_to_job(job)

applicant = Applicant.new(first_name: "Captain", last_name: "America")
applicant.save

applicant.apply_to_job(job)

applicant = Applicant.new(first_name: "Iron", last_name: "Man")
applicant.save

applicant.apply_to_job(job)

job_2 = Job.new(name: "Test", company_name: "test company", number_of_positions:  34)
job_2.save

100.times do |idx|
  applicant = Applicant.new(first_name: "name #{idx}", last_name: "last_name #{idx}")
  applicant.save
  applicant.apply_to_job(job_2)
end

Database.generate_applicant_status_report(job.id)

Database.generate_overview

Database.generate_applicant_status_report(job_2.id)
```