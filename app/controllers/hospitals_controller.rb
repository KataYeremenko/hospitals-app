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
    params.require(:hospital).permit(:name, :email, :phone, :address, :year)
  end
end