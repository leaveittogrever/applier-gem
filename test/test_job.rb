require 'minitest/autorun'
require './lib/models/job.rb'
require './lib/database/database'

class JobTest < Minitest::Test
  # Initialize
  def test_job_name
    job = Job.new(name: "Paul", company_name: "Acme", number_of_positions: 10)
    assert_equal "Paul", job.name
  end

  def test_job_company_name
    job = Job.new(name: "Paul", company_name: "Acme", number_of_positions: 10)
    assert_equal "Acme", job.company_name
  end

  def test_job_number_of_positions
    job = Job.new(name: "Paul", company_name: "Acme", number_of_positions: 10)
    assert_equal 10, job.number_of_positions
  end

  def test_id_is_initially_blank
    job = Job.new(name: "Paul", company_name: "Acme", number_of_positions: 10)
    assert_nil job.id
  end

  def test_created_at_is_initially_blank
    job = Job.new(name: "Paul", company_name: "Acme", number_of_positions: 10)
    assert_nil job.created_at
  end

  def test_updated_at_is_initially_blank
    job = Job.new(name: "Paul", company_name: "Acme", number_of_positions: 10)
    assert_nil job.updated_at
  end

  #Save
  def test_save_updates_the_id
    Database.stub(:insert_job, nil ) do
      Job.stub(:find, Job.new(name: "Paul", company_name: "Acme", number_of_positions: 10, id: 1)) do
        job = Job.new(name: "Paul", company_name: "Acme", number_of_positions: 10)
        job.save
        assert_equal(1, job.id)
      end
    end
  end
end