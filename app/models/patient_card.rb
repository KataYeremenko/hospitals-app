class PatientCard < ApplicationRecord
    belongs_to :hospital
    belongs_to :patient
end