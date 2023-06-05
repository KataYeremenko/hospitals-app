class PatientCardsController < ApplicationController
  def index
    @patientcards = PatientCard.all
  end

  def show
    @patientcard = PatientCard.find(params[:id])
  end

  def new
    @patientcard = PatientCard.new
  end

  def edit
    @patientcard = PatientCard.find(params[:id])
  end

  def create
    @patientcard = PatientCard.new(patient_card_params)

    if @patientcard.save
      redirect_to patient_card_path(@patientcard)
    else
      render :new
    end
  end

  def update
    @patientcard = PatientCard.find(params[:id])

    if @patientcard.update(patient_card_params)
      redirect_to patient_card_path(@patientcard)
    else
      render :edit
    end
  end

  def destroy
    @patientcard = PatientCard.find(params[:id])
    @patientcard.destroy
    redirect_to patient_cards_path
  end

  private

  def patient_card_params
    params.require(:patient_card).permit(:code, :description, :hospital_id, :patient_id)
  end
end