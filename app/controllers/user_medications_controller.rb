class UserMedicationsController < ApplicationController
  # Guarda el comparativo como destino de retorno ANTES de que authenticate_user!
  # redirija al login. Así, tras el registro o inicio de sesión, el usuario
  # vuelve a la página de donde vino (no a mis-medicinas).
  before_action :store_comparativo_location, only: %i[create], if: -> { !user_signed_in? }
  before_action :authenticate_user!

  private

  def store_comparativo_location
    store_location_for(:user, request.referer.presence || root_path)
  end

  public

  def index
    @user_medications = current_user.user_medications
                                    .includes(drug: :price_entries)
                                    .order("drugs.name")

    # Gasto mensual estimado: mejor precio disponible × 30 piezas por medicamento
    @monthly_costs = @user_medications.map do |um|
      best_price = um.drug.price_entries.min_by(&:price_per_unit)
      { drug: um.drug, price_entry: best_price,
        monthly_cost: best_price ? (best_price.price_per_unit * 30).round(2) : nil }
    end

    @total_monthly = @monthly_costs.sum { |mc| mc[:monthly_cost] || 0 }.round(2)
  end

  def create
    @drug = Drug.find(params[:drug_id])
    @user_medication = current_user.user_medications.find_or_initialize_by(drug: @drug)

    if @user_medication.new_record?
      @user_medication.save!
      @saved = true
    else
      @saved = true  # ya estaba guardado
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to comparar_path(@drug.slug) }
    end
  end

  def destroy
    @drug = Drug.find(params[:drug_id])
    current_user.user_medications.find_by(drug: @drug)&.destroy
    @saved = false

    respond_to do |format|
      # Solo responde con Turbo Stream si viene del comparativo; desde mis-medicinas redirige
      format.turbo_stream if request.referer&.include?("/comparar/")
      format.html { redirect_to mis_medicinas_path, notice: "Medicamento quitado de tu lista." }
    end
  end
end
