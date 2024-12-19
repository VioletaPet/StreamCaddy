import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["filterDropdown", "genreDropdown", "movies", "tvshows"];

  connect() {
    console.log(this.moviesTarget)
    // Parse the @user_providers passed via data attribute
    this.watchProviders = JSON.parse(this.element.querySelector(".scroll-box").dataset.providers);
  }

  filterContent() {
    const mediaType = String(this.filterDropdownTarget.value);
    const genres = this.getSelectedGenres();

    if (mediaType === "all") {
      this.fetchFilteredContent("movie", genres, this.watchProviders);
      this.fetchFilteredContent("tv", genres, this.watchProviders);
    } else {
      this.fetchFilteredContent(mediaType, genres, this.watchProviders);
    }
  }
  getSelectedGenres() {
    const selectedOptions = Array.from(this.genreDropdownTarget.selectedOptions);
    return selectedOptions.map(option => option.value);
  }

  fetchFilteredContent(mediaType, genres, watchProviders) {
    const genreParam = genres.join("|");
    fetch(`/media/filter?media_type=${mediaType}&genres=${genres.join("|")}&watch_providers=${watchProviders.join("|")}`, {
      headers: { "Accept": "text/plain" },
    })
      .then((response) => response.text())
      .then((data) => this.updateContent(data, mediaType))
      .catch((error) => console.error("Error:", error));
  }
  updateContent(data, mediaType) {
    console.log(this.moviesTarget)
    if (mediaType === "movie") {
      this.moviesTarget.innerHTML = data;
    } else if (mediaType === "tv") {
      this.tvshowsTarget.innerHTML = data;
    }
  }




  // filterContent(event) {
  //   const selectedFilter = event.target.value;

  //   switch (selectedFilter) {
  //     case "all":
  //       this.showAll();
  //       break;
  //     case "movies":
  //       this.showMovies();
  //       break;
  //     case "tvshows":
  //       this.showTVShows();
  //       break;
  //   }
  // }

  showAll() {
    this.moviesTarget.style.display = "block";
    this.tvshowsTarget.style.display = "block";
  }

  showMovies() {
    this.moviesTarget.style.display = "block";
    this.tvshowsTarget.style.display = "none";
  }

  showTVShows() {
    this.moviesTarget.style.display = "none";
    this.tvshowsTarget.style.display = "block";
  }
}
