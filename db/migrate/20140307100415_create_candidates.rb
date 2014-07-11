class CreateCandidates < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :candidates do |t|
      t.text :first_name
      t.text :middle_name
      t.text :last_name
      t.text :dob
      t.text :contact_number
      t.text :email_id
      t.text :address
      t.text :pg_degree
      t.text :pg_discipline
      t.text :pg_college
      t.text :pg_university
      t.text :pg_year
      t.text :pg_cpga
      t.text :gr_degree
      t.text :gr_discipline
      t.text :gr_college
      t.text :gr_university
      t.text :gr_year
      t.text :gr_cpga
      t.text :hsc_degree
      t.text :hsc_discipline
      t.text :hsc_college
      t.text :hsc_university
      t.text :hsc_year
      t.text :hsc_cpga
      t.text :sc_degree
      t.text :sc_discipline
      t.text :sc_college
      t.text :sc_university
      t.text :sc_year
      t.text :sc_cpga
      t.text :organization_a
      t.text :from_a
      t.text :to_a
      t.text :designation_a
      t.text :permanent_a
      t.text :reason_a
      t.text :organization_b
      t.text :from_b
      t.text :to_b
      t.text :designation_b
      t.text :permanent_b
      t.text :reason_b
      t.timestamps
    end
  end

  def self.down
    drop_table :candidates
  end
end
