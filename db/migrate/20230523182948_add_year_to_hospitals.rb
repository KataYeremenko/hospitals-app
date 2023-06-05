class AddYearToHospitals < ActiveRecord::Migration[7.0]
  def change
    add_column :hospitals, :year, :integer
  end
end
