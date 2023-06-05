require 'faker'

100.times do
	Hospital.create!(
		name: Faker::Company.name,
		email: Faker::Internet.email,
		phone: Faker::PhoneNumber.cell_phone_in_e164.gsub("+", ""),
		address: "#{Faker::Address.street_address} #{Faker::Address.street_name} St"
	)
end

department_list = ["Urology", "Neurology", "Hematology", "Dermatology", "Pediatrics", "Radiology", "Psychiatry", "Gastroenterology", "Cardiology", "Endocrinology", "Oncology"]
100.times do
	hospital = Hospital.order("RANDOM()").first
	Department.create(
		name: department_list.sample,
		description: Faker::Lorem.paragraph,
		hospital_id: hospital.id		
	)
end

specialty_list = ["Urologist", "Neurologist", "Hematologist", "Dermatologist", "Pediatrist", "Radiologist", "Psychiatrist", "Gastroenterologist", "Cardiologist", "Endocrinologist", "Oncologist"]
100.times do
	specialty = specialty_list.sample
	Specialty.create!(
		name: specialty,
		description: Faker::Lorem.paragraph(sentence_count: 5)
	)
end

100.times do
	department = Department.order("RANDOM()").first
	specialty = Specialty.order("RANDOM()").first

	Doctor.create!(
		name: Faker::Name.name,
		email: Faker::Internet.email,
		phone: Faker::PhoneNumber.cell_phone_in_e164.gsub("+", ""),
		department_id: department.id,
		specialty_id: specialty.id
	)
end

100.times do
	patient = Patient.create!(
		name: Faker::Name.name,
		birthdate: Faker::Date.birthday(min_age: 16, max_age: 100),
		phone: Faker::PhoneNumber.cell_phone_in_e164.gsub("+", ""),
		address: "#{Faker::Address.street_address} #{Faker::Address.street_name} St"
	)
	hospital = Hospital.order("RANDOM()").first

	PatientCard.create(
		code: Faker::Base.regexify("^[A-Z]{2}[0-9]{4}$"),
		description: Faker::Lorem.paragraph,
		hospital_id: hospital.id,
		patient_id: patient.id
	)
end