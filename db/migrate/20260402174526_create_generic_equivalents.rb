class CreateGenericEquivalents < ActiveRecord::Migration[7.1]
  def change
    create_table :generic_equivalents do |t|
      # drug_id = el genérico intercambiable
      t.references :drug, null: false, foreign_key: true
      # reference_drug_id = el innovador (FK manual porque references no admite alias directo)
      t.integer :reference_drug_id, null: false
      t.string :cofepris_registration

      t.timestamps
    end

    add_foreign_key :generic_equivalents, :drugs, column: :reference_drug_id
    add_index :generic_equivalents, [ :drug_id, :reference_drug_id ], unique: true
    add_index :generic_equivalents, :reference_drug_id
  end
end
