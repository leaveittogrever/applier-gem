class Applicant
  def self.find(first_name, last_name)
    Database::find_applicants(first_name, last_name).first
  end

  attr_accessor :first_name, :last_name, :id, :created_at, :updated_at

  def initialize(first_name:, last_name:, id:  nil, created_at: nil, updated_at: nil)
    @first_name = first_name
    @last_name  = last_name
    @id = id
    @created_at = created_at
    @updated_at = updated_at
  end

  def save
    Database.insert_applicant(self)
    applicant = Applicant.find(self.first_name, self.last_name)
    self.id = applicant.id
    self.created_at = applicant.created_at
    self.updated_at = applicant.updated_at
    self
  end

  def apply_to_job(job)
    p "#{first_name} #{last_name} is applying to #{job.name} at #{job.company_name}"
    applicant =
        if self.id == nil
          Applicant.find(self.first_name, self.last_name)
        else
          self
        end
    job_application = JobApplicant.new(job_id: job.id, applicant_id: applicant.id)
    job_application.apply_to_job
  end
end