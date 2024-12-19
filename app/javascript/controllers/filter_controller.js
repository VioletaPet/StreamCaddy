import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["filterDropdown", "genreDropdown", "movies", "tvshows"];

  connect() {
    console.log(this.moviesTarget);
    this.watchProviders = JSON.parse(
      this.element.querySelector(".scroll-box").dataset.providers
    );
  }

  filterContent() {
    const mediaType = this.filterDropdownTarget.value;
    const genres = this.getSelectedGenres();

    // Show or hide sections based on media type
    if (mediaType === "all") {
      this.showAll();
      this.fetchFilteredContent("movie", genres, this.watchProviders);
      this.fetchFilteredContent("tv", genres, this.watchProviders);
    } else if (mediaType === "movie") {
      this.showMovies();
      this.fetchFilteredContent("movie", genres, this.watchProviders);
    } else if (mediaType === "tv") {
      this.showTVShows();
      this.fetchFilteredContent("tv", genres, this.watchProviders);
    }
  }

  getSelectedGenres() {
    const selectedOptions = Array.from(this.genreDropdownTarget.selectedOptions);
    return selectedOptions.map((option) => option.value);
  }

  fetchFilteredContent(mediaType, genres, watchProviders) {
    const genreParam = genres.join("|");
    const url = `/media/filter?media_type=${mediaType}&genres=${genreParam}&watch_providers=${watchProviders.join("|")}`;

    fetch(url, {
      headers: { Accept: "text/plain" },
    })
      .then((response) => response.text())
      .then((data) => this.updateContent(data, mediaType))
      .catch((error) => console.error("Error:", error));
  }

  updateContent(data, mediaType) {
    if (mediaType === "movie") {
      this.moviesTarget.innerHTML = data;
    } else if (mediaType === "tv") {
      this.tvshowsTarget.innerHTML = data;
    }
  }

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
