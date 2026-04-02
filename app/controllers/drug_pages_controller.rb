class DrugPagesController < ApplicationController
  def show
    @drug_page = DrugPage.includes(:drug).find_by!(slug: params[:slug])
    @drug      = @drug_page.drug

    # Precio de referencia para el CTA del comparativo
    @best_price_entry = @drug.price_entries.includes(:pharmacy).min_by(&:price_per_unit)
  end
end
