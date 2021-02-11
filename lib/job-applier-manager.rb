class JobApplierManager
  def self.database
    begin
      PG.connect(dbname: "job_applier_manager")
    rescue PG::Error => e
      create_database
    ensure
      PG.connect(dbname: "job_applier_manager")
    end
  end

  def self.create_database
    begin
      connection = PG.connect(dbname: "job_applier_manager")
    rescue PG::Error => e
      connection = PG.connect(dbname: "postgres")
      connection.exec("CREATE DATABASE job_applier_manager")
    ensure
      connection.close if connection
    end

    connection = PG.connect(dbname: "job_applier_manager")
    connection.exec("CREATE TABLE IF NOT EXISTS jobs (
        id BIGSERIAL PRIMARY KEY,
        name character varying,
        company_name character varying,
        number_of_positions integer,
        created_at timestamp(6) without time zone NOT NULL,
        updated_at timestamp(6) without time zone NOT NULL
      );")
    connection.exec("CREATE TABLE IF NOT EXISTS applicants (
          id BIGSERIAL PRIMARY KEY,
          first_name character varying,
          last_name character varying,
          created_at timestamp(6) without time zone NOT NULL,
          updated_at timestamp(6) without time zone NOT NULL
      );")
    connection.exec("CREATE TABLE  IF NOT EXISTS job_applicants (
          id BIGSERIAL PRIMARY KEY,
          job_id bigint NOT NULL REFERENCES jobs(id),
          applicant_id bigint NOT NULL REFERENCES applicants(id),
          hired boolean DEFAULT false,
          created_at timestamp(6) without time zone NOT NULL,
          updated_at timestamp(6) without time zone NOT NULL
      );")
    connection.close if connection
  end
end
require 'pg'
require 'models/job'
require 'models/applicant'
require 'models/job_applicant'
require 'database/database'
