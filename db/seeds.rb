# Seeds idempotentes — seguros para correr en cada deploy.
# Usa find_or_create_by para no duplicar ni borrar datos existentes.

puts "Sincronizando seeds..."

# ── Farmacias ──────────────────────────────────────────────────────────────────

ahorro     = Pharmacy.find_or_create_by!(name: "Farmacias del Ahorro")    { |p| p.kind = "cadena" }
benavides  = Pharmacy.find_or_create_by!(name: "Farmacias Benavides")     { |p| p.kind = "cadena" }
similares  = Pharmacy.find_or_create_by!(name: "Farmacias Similares")     { |p| p.kind = "cadena" }

# ── Medicamentos ───────────────────────────────────────────────────────────────

glucophage = Drug.find_or_create_by!(slug: "glucophage-850mg") do |d|
  d.name                  = "Glucophage"
  d.active_ingredient     = "metformina"
  d.form                  = "tableta"
  d.dosage                = "850mg"
  d.requires_prescription = true
  d.therapeutic_group     = "Antidiabéticos"
  d.via                   = "oral"
  d.drug_type             = "referencia"
end

metformina = Drug.find_or_create_by!(slug: "metformina-850mg") do |d|
  d.name                  = "Metformina"
  d.active_ingredient     = "metformina"
  d.form                  = "tableta"
  d.dosage                = "850mg"
  d.requires_prescription = true
  d.therapeutic_group     = "Antidiabéticos"
  d.via                   = "oral"
  d.drug_type             = "generico_intercambiable"
end

atorvastatina = Drug.find_or_create_by!(slug: "atorvastatina-20mg") do |d|
  d.name                  = "Atorvastatina"
  d.active_ingredient     = "atorvastatina"
  d.form                  = "tableta"
  d.dosage                = "20mg"
  d.requires_prescription = true
  d.therapeutic_group     = "Hipolipemiantes"
  d.via                   = "oral"
  d.drug_type             = "generico_intercambiable"
end

# ── Equivalencias genéricas ────────────────────────────────────────────────────

GenericEquivalent.find_or_create_by!(drug: metformina, reference_drug: glucophage) do |ge|
  ge.cofepris_registration = "COFEPRIS-MET-850-001"
end

# ── Fichas educativas ──────────────────────────────────────────────────────────

DrugPage.find_or_create_by!(drug: metformina) do |dp|
  dp.slug = "metformina"
  dp.educational_content = <<~CONTENT
    === ¿Qué es la metformina?
    La metformina es el medicamento de primera línea para el tratamiento de la diabetes tipo 2. Pertenece a la familia de las biguanidas y actúa reduciendo la cantidad de glucosa que produce el hígado y mejorando la sensibilidad del organismo a la insulina. Se toma generalmente con los alimentos para reducir los efectos secundarios digestivos.

    === ¿Qué es un genérico intercambiable?
    Un genérico intercambiable es un medicamento que contiene exactamente el mismo principio activo, en la misma dosis y forma farmacéutica que el medicamento de referencia. COFEPRIS certifica que produce el mismo efecto terapéutico en el organismo, mediante pruebas de bioequivalencia. Esto significa que puedes usarlo de forma segura como sustituto del medicamento de referencia.

    === ¿Qué certifica COFEPRIS?
    COFEPRIS verifica que el genérico intercambiable tenga la misma calidad, pureza, potencia y estabilidad que el medicamento de referencia. El proceso incluye estudios de biodisponibilidad que demuestran que el ingrediente activo llega al torrente sanguíneo en la misma cantidad y velocidad.

    === ¿Qué puedo esperar como paciente?
    Al cambiar de un medicamento de referencia a metformina genérica intercambiable, puedes esperar el mismo efecto terapéutico. El empaque puede ser diferente, pero el principio activo y su funcionamiento son equivalentes. Muchos pacientes con diabetes tipo 2 en México utilizan metformina genérica con los mismos resultados clínicos, a una fracción del costo.

    === Antes de hacer cualquier cambio
    Siempre consulta a tu médico o farmacéutico antes de cambiar de medicamento, incluso cuando se trata de un genérico intercambiable certificado. Esta información es de carácter educativo y no sustituye el consejo médico profesional.
  CONTENT
end

DrugPage.find_or_create_by!(drug: atorvastatina) do |dp|
  dp.slug = "atorvastatina"
  dp.educational_content = <<~CONTENT
    === ¿Qué es la atorvastatina?
    La atorvastatina es un medicamento de la familia de las estatinas, utilizado para reducir los niveles de colesterol LDL ("colesterol malo") y triglicéridos en la sangre. Es uno de los medicamentos más prescritos en el mundo para la prevención de enfermedades cardiovasculares.

    === ¿Qué es un genérico intercambiable?
    Un genérico intercambiable contiene exactamente el mismo principio activo en la misma dosis que el medicamento de referencia, certificado por COFEPRIS mediante pruebas de bioequivalencia. Produce el mismo efecto terapéutico en el organismo.

    === ¿Qué certifica COFEPRIS?
    COFEPRIS certifica que el genérico intercambiable cumple con los mismos estándares de calidad, seguridad y eficacia que el medicamento de referencia, con la misma velocidad y concentración del ingrediente activo en el organismo.

    === ¿Qué puedo esperar como paciente?
    Al usar atorvastatina genérica intercambiable, puedes esperar el mismo efecto sobre tus niveles de colesterol. El ahorro puede ser significativo en tratamientos de largo plazo.

    === Antes de hacer cualquier cambio
    Siempre consulta a tu médico o farmacéutico antes de cambiar de medicamento. Esta información es de carácter educativo y no sustituye el consejo médico profesional.
  CONTENT
end

# ── Entradas de precio ─────────────────────────────────────────────────────────

[
  { drug: metformina,    pharmacy: ahorro,    price: 45.00,  units: 30, delivery: true },
  { drug: metformina,    pharmacy: benavides, price: 52.50,  units: 30, delivery: false },
  { drug: metformina,    pharmacy: similares, price: 38.00,  units: 30, delivery: false },
  { drug: glucophage,    pharmacy: ahorro,    price: 285.00, units: 30, delivery: true },
  { drug: glucophage,    pharmacy: benavides, price: 295.00, units: 30, delivery: false },
  { drug: atorvastatina, pharmacy: ahorro,    price: 68.00,  units: 30, delivery: true },
  { drug: atorvastatina, pharmacy: similares, price: 55.00,  units: 30, delivery: false }
].each do |e|
  PriceEntry.find_or_create_by!(drug: e[:drug], pharmacy: e[:pharmacy]) do |pe|
    pe.price_per_box = e[:price]
    pe.units_per_box = e[:units]
    pe.in_stock      = true
    pe.home_delivery = e[:delivery]
  end
end

# ── Usuario administrador ──────────────────────────────────────────────────────
# Solo crea el admin si no existe ninguno todavía

unless User.exists?(admin: true)
  User.create!(
    email:                 "admin@portusalud.org",
    password:              "admin1234",
    password_confirmation: "admin1234",
    admin:                 true
  )
  puts "  Admin creado: admin@portusalud.org"
end

puts "✓ Seeds completados: #{Pharmacy.count} farmacias, #{Drug.count} medicamentos, " \
     "#{PriceEntry.count} precios, #{User.where(admin: true).count} admin(s)"
