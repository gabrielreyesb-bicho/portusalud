module BadgesHelper
  # Parsea el contenido educativo estructurado con === como separador de sección.
  # Devuelve un array de { title:, body: }
  def parse_educational_content(text)
    return [] if text.blank?

    text.split(/^===\s*/).reject(&:blank?).map do |chunk|
      lines = chunk.strip.split("\n", 2)
      { title: lines[0]&.strip, body: lines[1]&.strip }
    end
  end
  # Devuelve el HTML del badge de tipo de medicamento según el sistema de diseño (§6.3)
  def drug_type_badge(drug_type)
    config = case drug_type
    when "generico_intercambiable"
      { label: "Genérico intercambiable", bg: "bg-pts-50",     text: "text-pts-700" }
    when "referencia"
      { label: "Medicamento referencia",   bg: "bg-blue-50",    text: "text-blue-700" }
    when "branded_generic"
      { label: "Branded generic",         bg: "bg-amber-50",   text: "text-amber-800" }
    else
      return ""
    end

    content_tag(:span, config[:label],
      class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{config[:bg]} #{config[:text]}")
  end

  def availability_badge(in_stock:, home_delivery:)
    tags = []
    if in_stock
      tags << content_tag(:span, "En stock",
        class: "inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-pts-50 text-pts-700")
    end
    if home_delivery
      tags << content_tag(:span, "Envío a domicilio",
        class: "inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-pts-50 text-pts-700")
    end
    unless in_stock
      tags << content_tag(:span, "Solo sucursal",
        class: "inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-600")
    end
    safe_join(tags, " ")
  end
end
