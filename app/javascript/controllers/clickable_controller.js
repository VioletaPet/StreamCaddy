import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.element.addEventListener("click", this.navigate.bind(this))
  }

  navigate(){
    if (this.urlValue) {
      window.location.href = this.urlValue;
  }
}
}
