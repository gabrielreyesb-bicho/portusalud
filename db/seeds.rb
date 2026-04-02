# Seeds de desarrollo — datos de prueba para trabajar las Etapas 2 y 3
# Ejecutar con: rails db:seed

puts "Limpiando datos existentes..."
UserMedication.destroy_all
PriceEntry.destroy_all
GenericEquivalent.destroy_all
DrugPage.destroy_all
Drug.destroy_all
Pharmacy.destroy_all
User.destroy_all

# ── Farmacias ──────────────────────────────────────────────────────────────────

puts "Creando farmacias..."

ahorro = Pharmacy.create!(
  name: "Farmacias del Ahorro",
  kind: "cadena"
)

benavides = Pharmacy.create!(
  name: "Farmacias Benavides",
  kind: "cadena"
)

similares = Pharmacy.create!(
  name: "Farmacias Similares",
  kind: "cadena"
)

# ── Medicamentos ───────────────────────────────────────────────────────────────

puts "Creando medicamentos..."

# Innovador (Glucophage)
glucophage = Drug.create!(
  name: "Glucophage",
  active_ingredient: "metformina",
  form: "tableta",
  dosage: "850mg",
  requires_prescription: true,
  therapeutic_group: "Antidiabéticos",
  via: "oral",
  slug: "glucophage-850mg",
  drug_type: "referencia"
)

# Genérico intercambiable de metformina
metformina = Drug.create!(
  name: "Metformina",
  active_ingredient: "metformina",
  form: "tableta",
  dosage: "850mg",
  requires_prescription: true,
  therapeutic_group: "Antidiabéticos",
  via: "oral",
  slug: "metformina-850mg",
  drug_type: "generico_intercambiable"
)

# Segundo genérico de prueba
atorvastatina = Drug.create!(
  name: "Atorvastatina",
  active_ingredient: "atorvastatina",
  form: "tableta",
  dosage: "20mg",
  requires_prescription: true,
  therapeutic_group: "Hipolipemiantes",
  via: "oral",
  slug: "atorvastatina-20mg",
  drug_type: "generico_intercambiable"
)

# ── Equivalencias genéricas ────────────────────────────────────────────────────

puts "Creando equivalencias genéricas..."

GenericEquivalent.create!(
  drug: metformina,               # genérico
  reference_drug: glucophage,     # innovador
  cofepris_registration: "COFEPRIS-MET-850-001"
)

# ── Fichas educativas ──────────────────────────────────────────────────────────

puts "Creando fichas educativas..."

DrugPage.create!(
  drug: metformina,
  slug: "metformina",
  educational_content: "La metformina es un medicamento genérico intercambiable certificado por COFEPRIS. "\
    "Tiene exactamente el mismo principio activo, la misma dosis y la misma forma farmacéutica que el medicamento innovador. "\
    "Su uso es seguro y está ampliamente recomendado para el control de la diabetes tipo 2."
)

DrugPage.create!(
  drug: atorvastatina,
  slug: "atorvastatina",
  educational_content: "La atorvastatina es un medicamento genérico intercambiable certificado por COFEPRIS. "\
    "Se utiliza para reducir los niveles de colesterol en sangre. "\
    "Tiene la misma eficacia que el medicamento innovador a una fracción del costo."
)

# ── Entradas de precio ─────────────────────────────────────────────────────────

puts "Creando entradas de precio..."

# Metformina en Farmacias del Ahorro
PriceEntry.create!(
  drug: metformina,
  pharmacy: ahorro,
  price_per_box: 45.00,
  units_per_box: 30,
  in_stock: true,
  home_delivery: true
)

# Metformina en Benavides
PriceEntry.create!(
  drug: metformina,
  pharmacy: benavides,
  price_per_box: 52.50,
  units_per_box: 30,
  in_stock: true,
  home_delivery: false
)

# Metformina en Similares
PriceEntry.create!(
  drug: metformina,
  pharmacy: similares,
  price_per_box: 38.00,
  units_per_box: 30,
  in_stock: true,
  home_delivery: false
)

# Glucophage (innovador) en Farmacias del Ahorro
PriceEntry.create!(
  drug: glucophage,
  pharmacy: ahorro,
  price_per_box: 285.00,
  units_per_box: 30,
  in_stock: true,
  home_delivery: true
)

# Glucophage en Benavides
PriceEntry.create!(
  drug: glucophage,
  pharmacy: benavides,
  price_per_box: 295.00,
  units_per_box: 30,
  in_stock: true,
  home_delivery: false
)

# Atorvastatina en Farmacias del Ahorro
PriceEntry.create!(
  drug: atorvastatina,
  pharmacy: ahorro,
  price_per_box: 68.00,
  units_per_box: 30,
  in_stock: true,
  home_delivery: true,
  promotion: "2x1 en segunda caja",
  promotion_expiry: 30.days.from_now.to_date
)

# Atorvastatina en Similares
PriceEntry.create!(
  drug: atorvastatina,
  pharmacy: similares,
  price_per_box: 55.00,
  units_per_box: 30,
  in_stock: true,
  home_delivery: false
)

# ── Usuario administrador ──────────────────────────────────────────────────────

puts "Creando usuario administrador..."

User.create!(
  email: "admin@portusalud.org",
  password: "admin1234",
  password_confirmation: "admin1234",
  admin: true
)

puts ""
puts "✓ Seeds completados:"
puts "  #{Pharmacy.count} farmacias"
puts "  #{Drug.count} medicamentos"
puts "  #{GenericEquivalent.count} equivalencias genéricas"
puts "  #{DrugPage.count} fichas educativas"
puts "  #{PriceEntry.count} entradas de precio"
puts "  #{User.count} usuario(s)"
