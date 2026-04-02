class AddDrugTypeToDrugs < ActiveRecord::Migration[7.1]
  def change
    add_column :drugs, :drug_type, :string, null: false, default: "generico_intercambiable"
    add_index :drugs, :drug_type
  end
end
