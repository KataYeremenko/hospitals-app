class PatientCard < ApplicationRecord
	belongs_to :hospital
	belongs_to :patient
	belongs_to :doctor
	
	validates :code, presence: true, length: { maximum: 10 }, format: { with: /\A[A-Z]{2}\d{4}\z/, message: "Invalid code format! Example: 'AB1234'" }
	validates :description, presence: true, length: { maximum: 1000 }

	def update_name(new_code)
		query = <<-SQL
			UPDATE patientcards SET code = ? WHERE id = ?
		SQL
		statement = ActiveRecord::Base.connection.raw_connection.prepare(query)
		statement.execute(new_code, id)
		statement.close
	end

	def update_description(new_description)
		query = <<-SQL
			UPDATE patientcards SET description = ? WHERE id = ?
		SQL
		statement = ActiveRecord::Base.connection.raw_connection.prepare(query)
		statement.execute(new_description, id)
		statement.close
	end
end