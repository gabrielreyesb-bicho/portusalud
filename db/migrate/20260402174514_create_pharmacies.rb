class CreatePharmacies < ActiveRecord::Migration[7.1]
  def change
    create_table :pharmacies do |t|
      t.string :name, null: false
      t.string :kind, null: false  # 'cadena' o 'autoservicio'

      t.timestamps
    end

    add_index :pharmacies, :name
  end
end
