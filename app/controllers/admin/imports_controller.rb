class Admin::ImportsController < ApplicationController
  before_action :authenticate_admin_user!

  layout "application"

  def new
    @result = nil
  end

  def template
    respond_to do |format|
      format.xlsx do
        response.headers["Content-Disposition"] =
          'attachment; filename="plantilla_portusalud.xlsx"'
      end
    end
  end

  def create
    file = params[:excel_file]

    unless file.present? && valid_excel_file?(file)
      flash.now[:alert] = "Selecciona un archivo .xlsx válido."
      @result = nil
      return render :new, status: :unprocessable_entity
    end

    @result = ExcelImporter.call(file: file)

    if @result.success?
      flash.now[:notice] = import_summary(@result.imported)
    else
      flash.now[:alert] = "Se encontraron #{@result.errors.size} error(es). Revisa la tabla a continuación."
    end

    render :new
  end

  private

  def valid_excel_file?(file)
    file.content_type.in?([
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "application/vnd.ms-excel",
      "application/octet-stream"
    ]) || file.original_filename.end_with?(".xlsx")
  end

  def import_summary(counts)
    parts = []
    parts << "#{counts[:drugs]} medicamentos"        if counts[:drugs] > 0
    parts << "#{counts[:pharmacies]} farmacias"      if counts[:pharmacies] > 0
    parts << "#{counts[:prices]} precios"            if counts[:prices] > 0
    parts << "#{counts[:equivalents]} equivalencias" if counts[:equivalents] > 0
    parts.empty? ? "No se importó ningún registro." : "Importados: #{parts.join(", ")}."
  end
end
