
class Database
  def self.connection
    @connection ||= JobApplierManager.database
  end

  def self.insert_job(job)
    connection.exec("INSERT INTO jobs(name, company_name, number_of_positions, created_at, updated_at)
      VALUES('#{job.name}', '#{job.company_name}', #{job.number_of_positions}, now(), now());")
  end

  def self.insert_applicant(applicant)
    connection.exec("INSERT INTO applicants(first_name, last_name, created_at, updated_at)
      VALUES('#{applicant.first_name}', '#{applicant.last_name}', now(), now());")
  end

  def self.find_job(job_id)
    result = connection.exec("SELECT * from jobs where id =#{job_id};")
    result.map { |sql_job| Job.new(sql_job.transform_keys(&:to_sym)) }.first
  end

  def self.find_applicant(applicant_id)
    result = connection.exec("SELECT * from applicants where id =#{applicant_id};")
    result.map { |sql_applicant| Applicant.new(sql_applicant.transform_keys(&:to_sym)) }.first
  end

  def self.find_jobs(name, company_name)
    result = connection.exec("SELECT * from jobs where name = '#{name}' and company_name = '#{company_name}';")
    result.map { |sql_job| Job.new(sql_job.transform_keys(&:to_sym)) }
  end

  def self.insert_job_applicant(job, applicant)
    connection.exec("INSERT INTO job_applicants(job_id, applicant_id, hired, created_at, updated_at)
    VALUES(#{job.id}, #{applicant.id},(select number_of_positions from jobs where id = #{job.id}) > (SELECT count(*) from job_applicants where job_id = #{job.id}), now(), now());")
  end

  def self.applicant_applies_to_job(job_applicant)
    if  job_applicant.job && job_applicant.applicant
      connection.exec("INSERT INTO job_applicants(job_id, applicant_id, hired, created_at, updated_at)
      VALUES(#{job_applicant.job_id}, #{job_applicant.applicant_id},(select number_of_positions from jobs where id = #{job_applicant.job_id}) > (SELECT count(*) from job_applicants where job_id = #{job_applicant.job_id}), now(), now());")
    else
      puts "job_applicant.job  = #{job_applicant.job} && job_applicant.applicant  = #{job_applicant.applicant}"
    end
  end

  def self.find_job_applicant(job_id, applicant_id)
    result =connection.exec("SELECT * FROM job_applicants where job_id = #{job_id} and applicant_id = #{applicant_id}")
    result.map do  |sql_job_applicant|
      symbolized_job_applicant = sql_job_applicant.transform_keys(&:to_sym)
      symbolized_job_applicant[:hired] = symbolized_job_applicant[:hired] == 't'

      JobApplicant.new(symbolized_job_applicant)
    end.first
  end

  def self.find_applicants(first_name, last_name)
    result =connection.exec("SELECT * from applicants where first_name = '#{first_name}' and last_name = '#{last_name}';")
    result.map { |sql_applicant| Applicant.new(sql_applicant.transform_keys(&:to_sym)) }
  end

  def self.generate_applicant_status_report(job_id)
    result = connection.exec("SELECT jobs.company_name as company, jobs.name as position, applicants.first_name || ' ' || applicants.last_name as name, job_applicants.hired as hired from jobs JOIN job_applicants on job_applicants.job_id = jobs.id JOIN applicants ON applicants.id = job_applicants.applicant_id  where jobs.id = #{job_id};")
    p "******APPLICANT STATUS REPORT *********"
    result.values.each do | value |
      p value.join(" | ")
    end
  end

  def self.generate_overview
    result = connection.exec("SELECT jobs.company_name, jobs.name, hired, count(jobs.id) from jobs JOIN job_applicants on job_applicants.job_id = jobs.id group by hired, jobs.company_name, jobs.name ORDER BY jobs.company_name ASC;")
    p "******JOBS OVERVIEW *********"
    result.values.each do | value |
      p value.join(" | ")
    end
  end
end