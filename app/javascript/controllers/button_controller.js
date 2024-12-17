import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"];
  static values = { toggled: Boolean };

  connect() {
    console.log("Controller connected");
    this.toggledValue = false;
  }

  toggle(event) {
    event.preventDefault();
    console.log("Button clicked");

    this.toggledValue = !this.toggledValue;

    if (this.toggledValue) {
      this.buttonTarget.classList.remove("fa-regular", "fa-plus");
      this.buttonTarget.classList.add("fa-solid", "fa-check");
    } else {
      this.buttonTarget.classList.remove("fa-solid", "fa-check");
      this.buttonTarget.classList.add("fa-regular", "fa-plus");
    }
  }
}
