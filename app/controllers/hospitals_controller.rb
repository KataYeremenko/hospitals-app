require 'csv'
require 'prawn'
require 'prawn/table'

class HospitalsController < ApplicationController
  def index
    hospitals = Hospital.all

    if params[:sort].present?
      hospitals = case params[:sort]
      when "id"
        hospitals.order!(id: params[:direction])
      when "departments_count"
        hospitals.left_outer_joins(:departments)
               .group(:id)
               .order!("COUNT(departments.id) #{params[:direction] == 'desc' ? 'DESC' : 'ASC'}")
      when "doctors_count"
        hospitals.left_outer_joins(:doctors)
               .group(:id)
               .order!("COUNT(doctors.id) #{params[:direction] == 'desc' ? 'DESC' : 'ASC'}")
      when "name"
        hospitals.order!(name: params[:direction])
      when "facility"
        hospitals.order!(facility_: params[:direction])
      when "city"
        hospitals.order!(city: params[:direction])
      when "rating"
        hospitals.order!(rating: params[:direction])
      end
    end

    @hospitals = HospitalQuery.new(hospitals.page(params[:page]).per(10))
    @hospitals = @hospitals.search(:name, params[:name]) if params[:name].present?
    @hospitals = @hospitals.result
  end

  def search
    hospitals = Hospital.all

    if params[:sort].present?
      hospitals = case params[:sort]
      when "id"
        hospitals.order!(id: params[:direction])
      when "departments_count"
        hospitals.left_outer_joins(:departments)
               .group(:id)
               .order!("COUNT(departments.id) #{params[:direction] == 'desc' ? 'DESC' : 'ASC'}")
      when "doctors_count"
        hospitals.left_outer_joins(:doctors)
               .group(:id)
               .order!("COUNT(doctors.id) #{params[:direction] == 'desc' ? 'DESC' : 'ASC'}")
      when "name"
        hospitals.order!(name: params[:direction])
      when "facility"
        hospitals.order!(facility: params[:direction])
      when "city"
        hospitals.order!(city: params[:direction])
      when "rating"
        hospitals.order!(rating: params[:direction])
      end
    end

    @hospitals = HospitalQuery.new(hospitals.page(params[:page]).per(10))
    @hospitals = @hospitals.search(:name, params[:name]) if params[:name].present?
    @hospitals = @hospitals.result

    render :index
  end
  
  def show
    @hospital = Hospital.find(params[:id])
    patients = @hospital.patients.page(params[:page]).per(10)

    if params[:sort].present?
      patients = case params[:sort]
      when "id"
        patients.order(id: params[:direction])
      when "name"
        patients.order(name: params[:direction])
      when "birthdate"
        patients.order(birthdate: params[:direction])
      when "phone"
        patients.order(phone: params[:direction])
      else
        patients
      end
    end

    @patients = PatientQuery.new(patients)
    @patients = @patients.search(:name, params[:name]) if params[:name].present?
    @patients = @patients.search(:age, params[:age]) if params[:age].present?
    @patients = @patients.search(:phone, params[:phone]) if params[:phone].present?
    @patients = @patients.sort(params[:sort], params[:direction]) if params[:sort].present?
    @patients = @patients.result

    @patientcards = PatientCard.where(patient_id: @patients.map(&:id)).index_by(&:patient_id)
  end

  def searchshow
    @hospital = Hospital.find(params[:id])
    @patients = PatientQuery.new(@hospital.patients.page(params[:page]).per(10))
    @patients = @patients.search(:name, params[:name]) if params[:name].present?
    @patients = @patients.search(:age, params[:age]) if params[:age].present?
    @patients = @patients.search(:phone, params[:phone]) if params[:phone].present?
    @patients = @patients.sort(params[:sort], params[:direction]) if params[:sort].present?
    @patients = @patients.result

    @patientcards = PatientCard.where(hospital_id: @hospital.id, patient_id: @patients.pluck(:id)).index_by(&:patient_id)

    render :show
  end

def download_csv
    filename = "hospitals_and_patients.csv"

    csv_headers = ["Hospital Name", "Hospital Email", "Hospital Phone", "Hospital Address", "Establishment Year", "Facility (Type)", "City", "Rating (Mortality)", "Department Count", "Doctor Count", "Patient Name", "Patient Phone", "Patient Address", "Patient Birthdate"]

    CSV.open(filename, "wb") do |csv|
      csv << csv_headers

      Hospital.includes(:patients).find_each do |hospital|
        hospital_data = [
          hospital.name,
          hospital.email,
          hospital.phone,
          hospital.address,
          hospital.year,
          hospital.facility,
          hospital.city,
          hospital.rating,
          hospital.departments.count,
          hospital.doctors.count
        ]
        csv << hospital_data
        hospital.patients.each_with_index do |patient, index|
          patient_data = [
            patient.name,
            patient.phone,
            patient.address,
            patient.birthdate
          ]
          csv << patient_data
        end
      end
    end

    send_file filename, filename: filename, type: "application/csv"
  end

  def download_pdf
    filename = "hospitals_and_patients.pdf"

    Prawn::Document.generate(filename) do |pdf|
      pdf.font_families.update("Georgia" => {
        normal: "#{Rails.root}/app/assets/fonts/NotoSansGeorgian-Regular.ttf",
        bold: "#{Rails.root}/app/assets/fonts/NotoSansGeorgian-Bold.ttf"
      })
      pdf.font "Georgia"

      hospitals = Hospital.includes(:patients)

      hospitals.each_with_index do |hospital, index|
        pdf.move_down(10)
        pdf.text "Hospital #{index + 1} Information", size: 14, style: :bold, align: :center

        hospital_data = [
          [{ content: 'Info', font_style: :bold }, { content: '', image: "#{Rails.root}/app/assets/images/hospital_info.png", fit: [20, 20] }],
          ["Hospital name", hospital.name],
          ["Email", hospital.email],
          ["Phone", hospital.phone],
          ["Address", hospital.address],
          ["Year of Establishment", hospital.year],
          ["Type", hospital.facility],
          ["City", hospital.city],
          ["Rating (Mortality)", hospital.rating],
          ["Number of departments", hospital.departments.count],
          ["Number of doctors", hospital.doctors.count]
        ]

        pdf.table(hospital_data, width: 400, cell_style: { borders: [], padding: [4, 2] })

        if hospital.patients.any?
          pdf.move_down(10)
          pdf.text "Patients", size: 14, style: :bold, align: :center

          patient_headers = [
            { content: "Info", width: 43 },
            { content: "Name", width: 94 },
            { content: "Birth", width: 50 },
            { content: "Phone", width: 69 },
            { content: "Address", width: 119 },
            { content: "Code", width: 68 },
            { content: "Doctor", width: 107 }
          ]

          patient_data = hospital.patients.map do |patient|
            [
              { content: '', image: "#{Rails.root}/app/assets/images/patient_info.png", fit: [20, 20] },
              patient.name,
              patient.birthdate,
              patient.phone,
              patient.address,
              patient.patient_card&.code,
              patient.patient_card&.doctor&.name
            ]
          end

          pdf.table([patient_headers] + patient_data, width: 550, cell_style: { borders: [], padding: [4, 2] })
        end

        pdf.start_new_page if index < hospitals.size - 1
      end
    end

    send_file filename, filename: filename, type: "application/pdf"
  end

  def download_pdf_with_id
    hospital = Hospital.find(params[:id])
    filename = "#{hospital.name}_and_patients.pdf".gsub(' ', '_')

    Prawn::Document.generate(filename) do |pdf|
      pdf.font_families.update("Georgia" => {
        normal: "#{Rails.root}/app/assets/fonts/NotoSansGeorgian-Regular.ttf",
        bold: "#{Rails.root}/app/assets/fonts/NotoSansGeorgian-Bold.ttf"
      })
      pdf.font "Georgia"

      pdf.move_down(10)
      pdf.text "Hospital Information", size: 14, style: :bold, align: :center

      hospital_data = [
        [{ content: 'Info', font_style: :bold }, { content: '', image: "#{Rails.root}/app/assets/images/hospital_info.png", fit: [20, 20] }],
        ["Hospital name", hospital.name],
        ["Email", hospital.email],
        ["Phone", hospital.phone],
        ["Address", hospital.address],
        ["Year of Establishment", hospital.year],
        ["Type", hospital.facility],
        ["City", hospital.city],
        ["Mort. Rating", hospital.rating],
        ["Number of departments", hospital.departments.count],
        ["Number of doctors", hospital.doctors.count]
      ]

      pdf.table(hospital_data, width: 400, cell_style: { borders: [], padding: [4, 2] })

      if hospital.patients.any?
        pdf.move_down(10)
        pdf.text "Patients", size: 14, style: :bold, align: :center

        patient_headers = [
            { content: "Info", width: 43 },
            { content: "Name", width: 94 },
            { content: "Birth", width: 50 },
            { content: "Phone", width: 69 },
            { content: "Address", width: 119 },
            { content: "Code", width: 68 },
            { content: "Doctor", width: 107 }
        ]

        patient_data = hospital.patients.map do |patient|
          [
            { content: '', image: "#{Rails.root}/app/assets/images/patient_info.png", fit: [20, 20] },
            patient.name,
            patient.birthdate,
            patient.phone,
            patient.address,
            patient.patient_card&.code,
            patient.patient_card&.doctor&.name
          ]
        end

        pdf.table([patient_headers] + patient_data, width: 550, cell_style: { borders: [], padding: [4, 2] })
      end
    end

    send_file filename, filename: filename, type: "application/pdf"
  end

  def new
    @hospital = Hospital.new
  end

  def create
    @hospital = Hospital.new(hospital_params)

    begin
      if @hospital.save
        redirect_to hospital_path(@hospital)
      else
        render :new
      end
    rescue ActiveRecord::RecordNotUnique => e
      flash[:error] = "An error occurred: #{e.message}"
      render :new
    end
  end

  def edit
    @hospital = Hospital.find(params[:id])
  end

  def update
    @hospital = Hospital.find(params[:id])

    begin
      if @hospital.update(hospital_params)
        redirect_to hospital_path(@hospital)
      else
        render :edit
      end
    rescue ActiveRecord::RecordNotUnique => e
      flash[:error] = "An error occurred: #{e.message}"
      render :edit
    end
  end

  def destroy
    @hospital = Hospital.find(params[:id])
    @hospital.destroy
    redirect_to hospitals_path
  end

  private

  def hospital_params
    params.require(:hospital).permit(:name, :email, :phone, :address, :year, :facility, :city, :rating)
  end
end