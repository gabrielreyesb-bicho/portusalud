class CreatePriceEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :price_entries do |t|
      t.references :drug, null: false, foreign_key: true
      t.references :pharmacy, null: false, foreign_key: true
      t.decimal :price_per_box, precision: 10, scale: 2, null: false
      t.integer :units_per_box, null: false
      # price_per_unit se calcula automáticamente en el modelo antes de guardar
      t.decimal :price_per_unit, precision: 10, scale: 2
      t.string :promotion               # descripción de la promoción vigente
      t.date :promotion_expiry
      t.boolean :in_stock, null: false, default: true
      t.boolean :home_delivery, null: false, default: false

      t.timestamps
    end

    # t.references ya crea índices en drug_id y pharmacy_id individualmente
    add_index :price_entries, [ :drug_id, :pharmacy_id ]
  end
end
