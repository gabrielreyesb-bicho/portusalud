class CreateDrugs < ActiveRecord::Migration[7.1]
  def change
    create_table :drugs do |t|
      t.string :name, null: false
      t.string :active_ingredient, null: false
      t.string :form                    # forma farmacéutica, ej. "tableta"
      t.string :dosage                  # ej. "850mg"
      t.boolean :requires_prescription, null: false, default: false
      t.string :therapeutic_group
      t.string :via                     # vía de administración, ej. "oral"
      t.string :slug, null: false       # URL /comparar/:slug

      t.timestamps
    end

    add_index :drugs, :slug, unique: true
    add_index :drugs, :active_ingredient
    # Índices GIN para búsqueda fuzzy con pg_trgm — se agregan después de habilitar la extensión
    add_index :drugs, :name, using: :gin, opclass: :gin_trgm_ops
    add_index :drugs, :active_ingredient, name: "index_drugs_on_active_ingredient_trgm", using: :gin, opclass: :gin_trgm_ops
  end
end
