require 'nokogiri'
require 'open-uri'
require 'faker'

namespace :parse do
  desc 'Parse hospitals name and add random records with these names to the hospitals table'
  task :hospitals => :environment do
    url = 'https://www.hospitalsafetygrade.org/all-hospitals'

    doc = Nokogiri::HTML(URI.open(url, "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36"))

    hospital_list = doc.css('#BlinkDBContent_849210 ul li')

    hospital_list.each do |hospital|
      name = hospital.css('a').first.text.strip
      email = Faker::Internet.unique.email
      phone = Faker::PhoneNumber.cell_phone_in_e164.delete("+")
      address = "#{Faker::Address.street_address} #{Faker::Address.street_name} Street"
      year = Faker::Number.between(from: 1700, to: 2023)

      Hospital.create!(
        name: name,
        email: email,
        phone: phone,
        address: address,
        year: year
      )
    end

    puts "Hospitals parsed and records added to the hospitals table: #{hospital_list.length}"
  end

  desc 'Parse first 100 hospitals name and add random records with these names to the hospitals table with creating other records for other dependent tables'
  task :completed_hospitals => :environment do
    specialty_list = ["Cardiologist",  "Dermatologist",  "Endocrinologist",  "Gastroenterologist",  "Hematologist",  "Neurologist",  "Oncologist",  "Pediatrist",  "Psychiatrist",  "Radiologist",  "Urologist",  "Therapist",  "Allergist",  "Anesthesiologist",  "Chiropractor",  "Dentist",  "ENT Specialist",  "General Practitioner",  "Infectious Disease Specialist",  "Nephrologist",  "Obstetrician/Gynecologist",  "Ophthalmologist",  "Orthopedic Surgeon",  "Physical Therapist",  "Pulmonologist",  "Rheumatologist",  "Sports Medicine Specialist",  "Surgeon"]
    department_list = ["Cardiology", "Dermatology", "Endocrinology", "Gastroenterology", "Hematology", "Neurology", "Oncology", "Pediatrics", "Psychiatry", "Radiology", "Urology", "Therapy", "Allergy and Immunology", "Anesthesiology", "Chiropractic", "Dentistry", "Otolaryngology", "Family Medicine", "Infectious Diseases", "Nephrology", "Obstetrics and Gynecology", "Ophthalmology", "Orthopedics", "Physical Therapy", "Pulmonology", "Rheumatology", "Sports Medicine", "Surgery"]

    specialties_to_create = specialty_list.map do |specialty|
      {
        name: specialty,
        description: Faker::Lorem.paragraph(sentence_count: 5)
      }
    end
    Specialty.create!(specialties_to_create)
    url = 'https://www.hospitalsafetygrade.org/all-hospitals'

    doc = Nokogiri::HTML(URI.open(url, "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36"))

    hospital_list = doc.css('#BlinkDBContent_849210 ul li')
    i = 0
    hospital_list.each do |hospital|
      if (i > 99)
        break
      end
      i = i + 1
      name = hospital.css('a').first.text.strip
      email = Faker::Internet.unique.email
      phone = Faker::PhoneNumber.cell_phone_in_e164.delete("+")
      address = "#{Faker::Address.street_address} #{Faker::Address.street_name} Street"
      year = Faker::Number.between(from: 1700, to: 2023)

      hospital = Hospital.create!(
        name: name,
        email: email,
        phone: phone,
        address: address,
        year: year
      )
      amount = Faker::Number.between(from: 2, to: 4)
      department_names = department_list.shuffle.take(amount)
      departments_to_create = department_names.map do |department|
        {
          name: department,
          description: Faker::Lorem.paragraph,
          hospital_id: hospital.id
        }
      end
      Department.create!(departments_to_create)

      unless Department.exists?(name: "Therapy", hospital_id: hospital.id)
        Department.create!(
          name: "Therapy",
          description: Faker::Lorem.paragraph,
          hospital_id: hospital.id
        )
      end
      Department.where(hospital_id: hospital.id).each do |department|
        specialty_name = specialty_list[department_list.index(department.name)]
        specialty = Specialty.find_by!(name: specialty_name)
        amount = Faker::Number.between(from: 2, to: 4)

        doctors_to_create = Array.new(amount) do
          {
            name: Faker::Name.name,
            email: Faker::Internet.unique.email,
            phone: Faker::PhoneNumber.cell_phone_in_e164.delete("+"),
            department_id: department.id,
            specialty_id: specialty.id
          }
        end

        doctors = Doctor.create!(doctors_to_create)

        if specialty_name == "Therapist"
          doctors.each do |doctor|
            10.times do
              patient = Patient.create!(
                name: Faker::Name.name,
                birthdate: Faker::Date.birthday(min_age: 16, max_age: 100),
                phone: Faker::PhoneNumber.cell_phone_in_e164.delete("+"),
                address: "#{Faker::Address.street_address} #{Faker::Address.street_name} Street"
              )

              PatientCard.create!(
                code: Faker::Base.regexify("^[A-Z]{2}[0-9]{4}$"),
                description: Faker::Lorem.paragraph,
                hospital_id: hospital.id,
                patient_id: patient.id,
                doctor_id: doctor.id
              )
            end
          end
        end
      end
    end

    puts "Hospitals parsed and records added to the hospitals table: #{hospital_list.length}"
  end
end