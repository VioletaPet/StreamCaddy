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
      console.log("Button active");

      const url = this.element.dataset.url;
      const mediaId = this.element.dataset.mediaId;
      const title = this.element.dataset.title;

      console.log("Sending fetch request to:", url);
      console.log("Media ID:", mediaId);

      if (url && mediaId) {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

        fetch(url, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": csrfToken,
          },
          body: JSON.stringify({
            media_id: mediaId,
            title: title
          }),
          });
        }
    } else {
      this.buttonTarget.classList.remove("fa-solid", "fa-check");
      this.buttonTarget.classList.add("fa-regular", "fa-plus");
    }
  }
}
