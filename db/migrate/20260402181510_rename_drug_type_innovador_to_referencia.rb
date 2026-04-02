class RenameDrugTypeInnovadorToReferencia < ActiveRecord::Migration[7.1]
  def up
    Drug.where(drug_type: "innovador").update_all(drug_type: "referencia")
    change_column_default :drugs, :drug_type, from: "generico_intercambiable", to: "generico_intercambiable"
  end

  def down
    Drug.where(drug_type: "referencia").update_all(drug_type: "innovador")
  end
end
