class ApplicationController < ActionController::Base
  # Requerido por Active Admin para verificar acceso al panel de administración
  def authenticate_admin_user!
    redirect_to new_user_session_path, alert: "No autorizado" unless current_user&.admin?
  end

  # La ubicación almacenada tiene prioridad siempre (ej: venía de un comparativo).
  # Solo si no hay ubicación previa, los admins van al dashboard y el resto a Mis medicinas.
  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      (resource.admin? ? admin_dashboard_path : mis_medicinas_path)
  end
end
