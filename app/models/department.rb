class Department < ApplicationRecord
	belongs_to :hospital
	has_many :doctors, dependent: :destroy

	validates :name, presence: true, length: { maximum: 100 }
	validates :description, presence: true, length: { maximum: 1000 }

	def update_name(new_name)
		query = <<-SQL
			UPDATE departments SET name = ? WHERE id = ?
		SQL
		statement = ActiveRecord::Base.connection.raw_connection.prepare(query)
		statement.execute(new_name, id)
		statement.close
	end

	def update_description(new_description)
		query = <<-SQL
			UPDATE departments SET description = ? WHERE id = ?
		SQL
		statement = ActiveRecord::Base.connection.raw_connection.prepare(query)
		statement.execute(new_description, id)
		statement.close
	end
end