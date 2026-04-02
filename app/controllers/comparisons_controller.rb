class ComparisonsController < ApplicationController
  def show
    @drug = Drug.find_by!(slug: params[:slug])

    # Carga todos los medicamentos con el mismo principio activo y dosis para mostrar
    # genéricos e innovador en el mismo comparativo
    related_drug_ids = Drug.where(
      active_ingredient: @drug.active_ingredient,
      dosage: @drug.dosage
    ).pluck(:id)

    @price_entries = PriceEntry.where(drug_id: related_drug_ids)
                               .includes(:drug, :pharmacy)
                               .order(:price_per_unit)

    @generic_entries   = @price_entries.select { |e| e.drug.generico? || e.drug.branded? }
    @innovador_entries = @price_entries.select { |e| e.drug.innovador? }

    # El precio más bajo de todo el comparativo → recibe el badge "Mejor precio"
    @best_price_entry = @price_entries.min_by(&:price_per_unit)

    # El precio más bajo entre los innovadores (para la sección separada)
    @best_innovador_entry = @innovador_entries.min_by(&:price_per_unit)

    # Datos para la calculadora de ahorro (solo si hay innovador y genérico)
    if @best_innovador_entry && @generic_entries.any?
      @best_generic_entry = @generic_entries.min_by(&:price_per_unit)
      @savings_per_unit   = @best_innovador_entry.price_per_unit - @best_generic_entry.price_per_unit
      @savings_monthly    = (@savings_per_unit * 30).round(2)   # estimado 30 piezas/mes
      @savings_annual     = (@savings_monthly * 12).round(2)
    end
  end
end
