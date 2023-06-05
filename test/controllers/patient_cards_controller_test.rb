require 'test_helper'

class PatientCardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    email = Faker::Internet.unique.email
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @user = User.create(email: email, password: 'password')
    sign_in @user
    @hospital = Hospital.create(name: 'Hospital1', email: 'hospital1@gmail.com', phone: '+380123456789', address: '123 Adr1 Street', year: '1955')
    @patient = Patient.create(name: 'Patient P1', birthdate: Faker::Date.birthday(min_age: 16, max_age: 100), phone: '+380234567891', address: '234 Adr2 Street')
    @department = Department.create(name: 'Therapy', description: 'description1', hospital_id: @hospital.id)
    @specialty = Specialty.create(name: 'Therapist', description: 'description2')
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @doctor = Doctor.create(
      name: 'Doctor D1',
      email: email,
      phone: '+380345678912',
      specialty_id: @specialty.id,
      department_id: @department.id
    )
    @patientcard = PatientCard.create!(code: Faker::Base.regexify("^[A-Z]{2}[0-9]{4}$"), description: Faker::Lorem.paragraph, hospital_id: @hospital.id, patient_id: @patient.id, doctor_id: @doctor.id)
    9.times do |i|
      patient = Patient.create(name: "Patient P#{i + 2}", birthdate: Faker::Date.birthday(min_age: 16, max_age: 100), phone: "+380#{i + 2}0000000", address: '345 Adr3 Street')
      PatientCard.create!(code: Faker::Base.regexify("^[A-Z]{2}[0-9]{4}$"), description: Faker::Lorem.paragraph, hospital_id: @hospital.id, patient_id: patient.id, doctor_id: @doctor.id)
    end
  end

  test "should get index" do
    get patient_cards_url
    assert_response :success
    assert_select 'table tr', count: 11
    assert_select 'a', '2'
    get patient_cards_url(page: 2)
    assert_response :success
    assert_select 'table tr', count: 3
  end

  test "should get show" do
    get patient_cards_url(@patientcard)
    assert_response :success
  end

  test "should get new" do
    get new_patient_card_url
    assert_response :success
  end

  test "should get edit" do
    get edit_patient_card_url(@patientcard)
    assert_response :success
  end

  test "should create patientcard" do
    assert_difference('PatientCard.count', 1) do
      post patient_cards_url, params: { patient_card: { code: @patientcard.code, description: @patientcard.description, hospital_id: @patientcard.hospital_id, patient_id: @patientcard.patient_id, doctor_id: @doctor.id } }
    end

    assert_redirected_to patient_card_url(PatientCard.last)
  end

  test "should update patientcard" do
    patch patient_card_url(@patientcard), params: {
      patient_card: {
        code: 'ZW1357',
        description: Faker::Lorem.paragraph,
        hospital_id: Hospital.last.id,
        patient_id: Patient.last.id,
        doctor_id: Doctor.last.id
      }
    }

    assert_redirected_to patient_card_url(@patientcard)

    @patientcard.reload

    assert_equal @patientcard.code, 'ZW1357'
  end

  test "should destroy patientcard" do
    assert_difference('PatientCard.count', -1) do
      delete patient_card_url(@patientcard)
    end

    assert_redirected_to patient_cards_url
  end

  teardown do
    @hospital.destroy
    @patient.destroy
    @department.destroy
    @specialty.destroy
    @doctor.destroy
    @patientcard.destroy
    sign_out @user
    @user.destroy
  end
end