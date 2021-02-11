require 'minitest/autorun'
require './lib/models/applicant.rb'
require './lib/database/database'
require './lib/models/job_applicant'

class ApplicantTest < Minitest::Test
  # Initialize
  def test_applicant_name
    applicant = Applicant.new(first_name: "Paul", last_name: "Grever")
    assert_equal "Paul", applicant.first_name
  end

  def test_applicant_last_name
    applicant = Applicant.new(first_name: "Paul", last_name: "Grever")
    assert_equal "Grever", applicant.last_name
  end

  #Save
  def test_save_updates_the_id
    Database.stub(:insert_applicant, nil) do
      Applicant.stub(:find, Applicant.new(first_name: "Paul", last_name: "Grever", id: 10)) do
        applicant = Applicant.new(first_name: "Paul", last_name: "Grever")
        applicant.save
        assert_equal(10, applicant.id)
      end
    end
  end

  # Apply_to_job
  def test_apply_to_job_with_id
    mock_job_applicant = MiniTest::Mock.new
    mock_job_applicant.expect(:apply_to_job, nil)
    JobApplicant.stub(:new, mock_job_applicant) do
      applicant = Applicant.new(first_name: "Paul", last_name: "Grever", id: 10)
      job = Job.new(name: "Paul", company_name: "Acme", number_of_positions: 10, id: 1)
      applicant.apply_to_job(job)
    end
    mock_job_applicant.verify
  end
end
