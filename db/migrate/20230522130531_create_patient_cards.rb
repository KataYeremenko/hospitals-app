class CreatePatientCards < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_cards do |t|
      t.string :code
      t.text :description
      t.references :hospital, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
