class Job
  def self.find(name, company_name)
    Database::find_jobs(name, company_name).first
  end

  attr_accessor :name, :company_name, :number_of_positions, :id, :created_at, :updated_at

  def initialize(name:, company_name:, number_of_positions:, id:  nil, created_at: nil, updated_at: nil)
    @name = name
    @company_name  = company_name
    @number_of_positions = number_of_positions
    @id = id
    @created_at = created_at
    @updated_at = updated_at
  end

  def save
    Database.insert_job(self)
    job = Job.find(self.name, self.company_name)
    self.id = job.id
    self.created_at = job.created_at
    self.updated_at = job.updated_at
    self
  end
end

