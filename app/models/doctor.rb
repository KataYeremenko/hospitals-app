class Doctor < ApplicationRecord
	belongs_to :department
	belongs_to :specialty
	has_many :patient_cards, dependent: :destroy

	validates :name, presence: true, length: { maximum: 255 }
	validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email format!" }
	validates :phone, presence: true, length: { maximum: 20 }, format: { with: /\A\+?\d+\z/, message: "Invalid phone format!" }

	def update_name(new_name)
		self.name = new_name
		save
	end

	def update_email(new_email)
		self.email = new_email
		save
	end

	def update_phone(new_phone)
		self.phone = new_phone
		save
	end
end