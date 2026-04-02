class CreateUserMedications < ActiveRecord::Migration[7.1]
  def change
    create_table :user_medications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :drug, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_medications, [ :user_id, :drug_id ], unique: true
  end
end
