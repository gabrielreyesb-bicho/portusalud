class CreateDrugPages < ActiveRecord::Migration[7.1]
  def change
    create_table :drug_pages do |t|
      # index: { unique: true } crea el índice único directamente, sin duplicar
      t.references :drug, null: false, foreign_key: true, index: { unique: true }
      t.string :slug, null: false        # URL pública /medicamento/:slug
      t.text :educational_content

      t.timestamps
    end

    add_index :drug_pages, :slug, unique: true
  end
end
