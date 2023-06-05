class AddCvsFieldsToHospitals < ActiveRecord::Migration[7.0]
  def change
    add_column :hospitals, :facility, :string
    add_column :hospitals, :city, :string
    add_column :hospitals, :rating, :string
  end
end
