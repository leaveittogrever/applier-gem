class JobApplicant
  attr_reader :job_id, :applicant_id, :id, :created_at, :updated_at
  attr_accessor :hired

  def initialize(job_id:, applicant_id:, hired: false, id: nil, created_at: nil, updated_at: nil)
    @job_id = job_id
    @applicant_id = applicant_id
    @hired = hired
    @id = id
    @created_at = created_at
    @updated_at = updated_at
  end

  def job
    Database.find_job(job_id)
  end

  def applicant
    Database.find_applicant(applicant_id)
  end

  def apply_to_job
    Database.applicant_applies_to_job(self)
    get_applicant_results
  end

  def get_applicant_results
    result = Database.find_job_applicant(job_id, applicant_id)
    if result.hired
      p "Congrats you have been hired"
    else
      p "Sorry the positions have all been filed. If more positions open, we will be in touch."
    end
  end
end