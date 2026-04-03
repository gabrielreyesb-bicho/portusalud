import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label"]

  async share(event) {
    event.preventDefault()
    const url  = window.location.href
    const title = document.title

    if (navigator.share) {
      try {
        await navigator.share({ title, url })
      } catch (_) {}
    } else {
      await navigator.clipboard.writeText(url)
      this.labelTarget.textContent = "¡Enlace copiado!"
      setTimeout(() => { this.labelTarget.textContent = "Compartir" }, 2000)
    }
  }
}
