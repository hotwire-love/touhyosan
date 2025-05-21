import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "preview"]

  connect() {
    this.form = document.createElement("form")
    this.form.action = "/markdown_preview"
    this.form.method = "post"

    // Turbo Streamを有効化
    this.form.setAttribute("data-turbo-stream", "true")

    // CSRFトークンの追加
    const csrfToken = document.querySelector("[name='csrf-token']")
    if (csrfToken) {
      const hiddenField = document.createElement("input")
      hiddenField.type = "hidden"
      hiddenField.name = "authenticity_token"
      hiddenField.value = csrfToken.content
      this.form.appendChild(hiddenField)
    }

    // テキストエリアの input 用の hidden field
    this.textField = document.createElement("input")
    this.textField.type = "hidden"
    this.textField.name = "text"
    this.form.appendChild(this.textField)

    document.body.appendChild(this.form)
  }

  disconnect() {
    this.form.remove()
  }

  update() {
    this.textField.value = this.editorTarget.value
    this.form.requestSubmit()
  }
}
