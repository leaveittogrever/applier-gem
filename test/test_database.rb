require 'minitest/autorun'
require './lib/database/database'
require './lib/job-applier-manager'

class DatabaseTest < Minitest::Test

  def test_database_methods
    mock_database = MiniTest::Mock.new
    applicant = Applicant.new(first_name: "Paul", last_name: "Grever")
    job = Job.new(name: 'name', company_name: "company", number_of_positions: 10)

    insert_applicant_sql = "INSERT INTO applicants(first_name, last_name, created_at, updated_at)
      VALUES('#{applicant.first_name}', '#{applicant.last_name}', now(), now());"
    mock_database.expect(:exec, nil, [insert_applicant_sql])

    insert_job_sql = "INSERT INTO jobs(name, company_name, number_of_positions, created_at, updated_at)
      VALUES('#{job.name}', '#{job.company_name}', #{job.number_of_positions}, now(), now());"
    mock_database.expect(:exec, nil, [insert_job_sql])

    find_job_sql = "SELECT * from jobs where id =#{job.id};"
    mock_database.expect(:exec, [{'name' => job.name, 'company_name' => job.company_name, 'number_of_positions' => job.number_of_positions, 'id' => 10, 'created_at' => Time.now.to_i, 'updated_at' => Time.now.to_i}], [find_job_sql])

    JobApplierManager.stub(:database, mock_database) do
      Database.insert_applicant(applicant)
      Database.insert_job(job)
      found_job = Database.find_job(job.id)
      assert_equal(found_job.name, job.name)

    end
    mock_database.verify
  end

end