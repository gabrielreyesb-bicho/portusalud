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
  educational_content: <<~CONTENT
    === ¿Qué es la metformina?
    La metformina es el medicamento de primera línea para el tratamiento de la diabetes tipo 2. Pertenece a la familia de las biguanidas y actúa reduciendo la cantidad de glucosa que produce el hígado y mejorando la sensibilidad del organismo a la insulina. Se toma generalmente con los alimentos para reducir los efectos secundarios digestivos.

    === ¿Qué es un genérico intercambiable?
    Un genérico intercambiable es un medicamento que contiene exactamente el mismo principio activo, en la misma dosis y forma farmacéutica que el medicamento de referencia. COFEPRIS (Comisión Federal para la Protección contra Riesgos Sanitarios) certifica que produce el mismo efecto terapéutico en el organismo, mediante pruebas de bioequivalencia. Esto significa que puedes usarlo de forma segura como sustituto del medicamento de referencia.

    === ¿Qué certifica COFEPRIS?
    COFEPRIS verifica que el genérico intercambiable tenga la misma calidad, pureza, potencia y estabilidad que el medicamento de referencia. El proceso incluye estudios de biodisponibilidad que demuestran que el ingrediente activo llega al torrente sanguíneo en la misma cantidad y velocidad. Solo los medicamentos que pasan estas pruebas reciben la certificación de intercambiable.

    === ¿Qué puedo esperar como paciente?
    Al cambiar de un medicamento de referencia a metformina genérica intercambiable, puedes esperar el mismo efecto terapéutico. El empaque y la apariencia de la tableta pueden ser diferentes, pero el principio activo y su funcionamiento son equivalentes. Muchos pacientes con diabetes tipo 2 en México utilizan metformina genérica con los mismos resultados clínicos que el medicamento de referencia, a una fracción del costo.

    === Antes de hacer cualquier cambio
    Siempre consulta a tu médico o farmacéutico antes de cambiar de medicamento, incluso cuando se trata de un genérico intercambiable certificado. Esta información es de carácter educativo y no sustituye el consejo médico profesional.
  CONTENT
)

DrugPage.create!(
  drug: atorvastatina,
  slug: "atorvastatina",
  educational_content: <<~CONTENT
    === ¿Qué es la atorvastatina?
    La atorvastatina es un medicamento de la familia de las estatinas, utilizado para reducir los niveles de colesterol LDL ("colesterol malo") y triglicéridos en la sangre, y para aumentar el colesterol HDL ("colesterol bueno"). Es uno de los medicamentos más prescritos en el mundo para la prevención de enfermedades cardiovasculares como infartos y derrames cerebrales.

    === ¿Qué es un genérico intercambiable?
    Un genérico intercambiable contiene exactamente el mismo principio activo en la misma dosis que el medicamento de referencia, y ha sido certificado por COFEPRIS mediante pruebas de bioequivalencia. Esto garantiza que produce el mismo efecto terapéutico en el organismo. La única diferencia puede estar en los excipientes (componentes inactivos) y en la presentación.

    === ¿Qué certifica COFEPRIS?
    COFEPRIS certifica que el genérico intercambiable cumple con los mismos estándares de calidad, seguridad y eficacia que el medicamento de referencia. Los estudios de bioequivalencia demuestran que el ingrediente activo —en este caso la atorvastatina— actúa de la misma manera en el organismo, con la misma velocidad y en la misma concentración.

    === ¿Qué puedo esperar como paciente?
    Al usar atorvastatina genérica intercambiable, puedes esperar el mismo efecto sobre tus niveles de colesterol. Los controles periódicos de laboratorio mostrarán resultados equivalentes a los del medicamento de referencia. El ahorro puede ser significativo, especialmente en tratamientos de largo plazo como los que requieren las enfermedades cardiovasculares crónicas.

    === Antes de hacer cualquier cambio
    Siempre consulta a tu médico o farmacéutico antes de cambiar de medicamento. Esta información es de carácter educativo y no sustituye el consejo médico profesional. No suspendas ni modifiques tu tratamiento sin indicación médica.
  CONTENT
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
