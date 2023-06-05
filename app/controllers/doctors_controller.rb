class DoctorsController < ApplicationController

  def index
    @doctors = DoctorQuery.new(Doctor.page(params[:page]).per(10))
    @doctors = @doctors.sort(params[:sort], params[:direction]) if params[:sort].present?
    @doctors = @doctors.search(:name, params[:name]) if params[:name].present?
    @doctors = @doctors.result
  end
  
  def search
    @doctors = DoctorQuery.new(Doctor.page(params[:page]).per(10))
    @doctors = @doctors.sort(params[:sort], params[:direction]) if params[:sort].present?
    @doctors = @doctors.search(:name, params[:name]) if params[:name].present?
    @doctors = @doctors.result

    render :index
  end

  def show
    @doctor = Doctor.find(params[:id])
  end

  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(doctor_params)

    if @doctor.save
      redirect_to doctor_path(@doctor)
    else
      render :new
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
  end

  def update
    @doctor = Doctor.find(params[:id])

    if @doctor.update(doctor_params)
      redirect_to doctor_path(@doctor)
    else
      puts @doctor.errors.full_messages
      render :edit
    end
  end

  def destroy
    @doctor = Doctor.find(params[:id])
    @doctor.destroy
    redirect_to doctors_path
  end

  private

  def doctor_params
    params.require(:doctor).permit(:name, :email, :phone, :specialty_id, :department_id)
  end
end