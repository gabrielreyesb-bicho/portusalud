# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Panel principal"

  content title: "portusalud — Panel de administración" do

    columns do
      column do
        panel "Estado de datos" do
          table_for [
            { entidad: "Medicamentos",       total: Drug.count,         ultima_act: Drug.maximum(:updated_at) },
            { entidad: "Farmacias",           total: Pharmacy.count,     ultima_act: Pharmacy.maximum(:updated_at) },
            { entidad: "Entradas de precio",  total: PriceEntry.count,   ultima_act: PriceEntry.maximum(:updated_at) },
            { entidad: "Equivalencias",       total: GenericEquivalent.count, ultima_act: GenericEquivalent.maximum(:updated_at) },
            { entidad: "Fichas educativas",   total: DrugPage.count,     ultima_act: DrugPage.maximum(:updated_at) },
            { entidad: "Usuarios",            total: User.count,         ultima_act: User.maximum(:updated_at) }
          ] do
            column("Entidad")     { |r| r[:entidad] }
            column("Total")       { |r| r[:total] }
            column("Última actualización") do |r|
              r[:ultima_act] ? l(r[:ultima_act], format: :short) : "—"
            end
          end
        end
      end

      column do
        panel "Acciones rápidas" do
          ul do
            li link_to("Importar desde Excel →", admin_import_path)
            li link_to("Ver medicamentos →",    admin_drugs_path)
            li link_to("Ver precios →",         admin_price_entries_path)
            li link_to("Ver farmacias →",       admin_pharmacies_path)
          end
        end

        panel "Precios más recientes" do
          table_for PriceEntry.includes(:drug, :pharmacy).order(updated_at: :desc).limit(5) do
            column("Medicamento") { |e| e.drug.name }
            column("Farmacia")    { |e| e.pharmacy.name }
            column("$/pieza")     { |e| number_with_precision(e.price_per_unit, precision: 2) }
            column("Actualizado") { |e| l(e.updated_at, format: :short) }
          end
        end
      end
    end

  end
end
