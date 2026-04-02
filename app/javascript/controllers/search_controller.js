import { Controller } from "@hotwired/stimulus"

// Maneja el autocompletado del buscador con debounce de 200ms
export default class extends Controller {
  static targets = ["input", "suggestions"]

  connect() {
    this.debounceTimer = null
    // Cierra sugerencias al hacer clic fuera del buscador
    this.boundHandleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.boundHandleOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.boundHandleOutsideClick)
    clearTimeout(this.debounceTimer)
  }

  autocomplete() {
    clearTimeout(this.debounceTimer)
    const q = this.inputTarget.value.trim()

    if (q.length < 2) {
      this.clearSuggestions()
      return
    }

    this.debounceTimer = setTimeout(() => {
      fetch(`/buscar/autocomplete?q=${encodeURIComponent(q)}`, {
        headers: { "Accept": "text/vnd.turbo-stream.html" }
      })
      .then(response => response.text())
      .then(html => window.Turbo.renderStreamMessage(html))
    }, 200)
  }

  clearSuggestions() {
    const el = document.getElementById("autocomplete_suggestions")
    if (el) el.innerHTML = ""
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.clearSuggestions()
    }
  }

  // Navega al comparativo al seleccionar una sugerencia
  selectSuggestion(event) {
    const slug = event.currentTarget.dataset.slug
    if (slug) {
      window.location.href = `/comparar/${slug}`
    }
  }
}
