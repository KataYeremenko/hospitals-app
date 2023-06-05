require 'test_helper'

class HospitalsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    email = Faker::Internet.unique.email
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @user = User.create(email: email, password: 'password')
    sign_in @user
    while User.exists?(email: email)
      email = Faker::Internet.unique.email
    end
    @hospital = Hospital.create(name: 'Hospital1', email: email, phone: '+380123456789', address: '123 Adr1 Street', year: '1955')
    9.times do |i|
      while User.exists?(email: email)
        email = Faker::Internet.unique.email
      end
      while Hospital.exists?(email: email)
        email = Faker::Internet.unique.email
      end
      Hospital.create(name: "Hospital#{i + 2}", email: email, phone: "+380123456789", address: "123 Adr#{i + 1} Street", year: "1955")
    end
  end

  test "should get index" do
    get hospitals_url
    assert_response :success
    assert_select 'table tr', count: 11
    assert_select 'a', '2'
    get hospitals_url(page: 2)
    assert_response :success
    assert_select 'table tr', count: 3
  end

  test "should get show" do
    get hospital_url(@hospital)
    assert_response :success
  end

  test "should get new" do
    get new_hospital_url
    assert_response :success
  end

  test "should create hospital" do
    assert_difference('Hospital.count', 1) do
      post hospitals_url, params: { hospital: { name: @hospital.name, email: @hospital.email, phone: @hospital.phone, address: @hospital.address, year: @hospital.year } }
    end

    assert_redirected_to hospital_url(Hospital.last)
  end

  test "should get edit" do
    get edit_hospital_url(@hospital)
    assert_response :success
  end

  test "should update hospital" do
    patch hospital_url(@hospital), params: {
      hospital: {
        name: 'Hospital2',
        email: Faker::Internet.unique.email,
        phone: '+380234567891',
        address: "#{Faker::Address.street_address} #{Faker::Address.street_name} Street",
        year: '2023'
      }
    }
    assert_redirected_to hospital_url(@hospital)
    
    @hospital.reload
    
    assert_equal 'Hospital2', @hospital.name
  end

  test "should destroy hospital" do
    assert_difference('Hospital.count', -1) do
      delete hospital_url(@hospital)
    end

    assert_redirected_to hospitals_url
  end

  teardown do
    @hospital.destroy
    sign_out @user
    @user.destroy
  end
end