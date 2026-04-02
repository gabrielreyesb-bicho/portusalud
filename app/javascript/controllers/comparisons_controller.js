import { Controller } from "@hotwired/stimulus"

// Maneja filtros, ordenamiento y toggle tarjetas/tabla del comparativo
export default class extends Controller {
  static targets = ["card", "filterBtn", "sortSelect", "cardList",
                    "cardsView", "tableView", "viewBtn"]
  static values  = { view: { type: String, default: "cards" } }

  connect() {
    this.activeFilter = "todos"
  }

  // ── Toggle de vista ────────────────────────────────────────────────────────

  toggleView(event) {
    const view = event.currentTarget.dataset.view
    this.viewValue = view

    // Muestra/oculta las secciones
    this.cardsViewTarget.classList.toggle("hidden", view !== "cards")
    this.tableViewTarget.classList.toggle("hidden", view !== "table")

    // Estilos de los botones de toggle
    this.viewBtnTargets.forEach(btn => {
      const isActive = btn.dataset.view === view
      btn.classList.toggle("bg-pts-500",   isActive)
      btn.classList.toggle("text-white",   isActive)
      btn.classList.toggle("border-pts-500", isActive)
      btn.classList.toggle("text-pts-600", !isActive)
      btn.classList.toggle("border-pts-200", !isActive)
    })
  }

  // ── Filtros ────────────────────────────────────────────────────────────────

  filter(event) {
    const btn = event.currentTarget
    const type = btn.dataset.filterType
    this.activeFilter = type

    // Actualiza estilos de botones de filtro
    this.filterBtnTargets.forEach(b => {
      const isActive = b.dataset.filterType === type
      b.classList.toggle("bg-pts-500",     isActive)
      b.classList.toggle("text-white",     isActive)
      b.classList.toggle("border-pts-500", isActive)
      b.classList.toggle("text-pts-700",   !isActive)
      b.classList.toggle("border-pts-200", !isActive)
      b.classList.toggle("hover:border-pts-400", !isActive)
    })

    // Muestra/oculta tarjetas
    this.cardTargets.forEach(card => {
      const visible = this._matchesFilter(card, type)
      card.classList.toggle("hidden", !visible)
    })

    // Muestra/oculta filas de la tabla
    this.element.querySelectorAll("[data-table-row]").forEach(row => {
      const visible = this._matchesFilter(row, type)
      row.classList.toggle("hidden", !visible)
    })
  }

  _matchesFilter(el, type) {
    const drugType = el.dataset.drugType
    const hasPromo = el.dataset.hasPromotion === "true"
    if (type === "todos")     return true
    if (type === "genericos") return drugType === "generico_intercambiable" || drugType === "branded_generic"
    if (type === "innovador") return drugType === "referencia"
    if (type === "promocion") return hasPromo
    return true
  }

  // ── Ordenamiento ───────────────────────────────────────────────────────────

  sort(event) {
    const by = event.currentTarget.value
    const lists = this.cardListTargets

    lists.forEach(list => {
      const cards = Array.from(list.querySelectorAll("[data-comparisons-target='card']"))
      cards.sort((a, b) => this._sortValue(a, by) - this._sortValue(b, by) ||
                           a.dataset.pharmacyName.localeCompare(b.dataset.pharmacyName, "es"))
      cards.forEach(card => list.appendChild(card))
    })
  }

  _sortValue(el, by) {
    if (by === "precio_pieza") return parseFloat(el.dataset.pricePerUnit)
    if (by === "precio_caja")  return parseFloat(el.dataset.pricePerBox)
    return 0
  }
}
