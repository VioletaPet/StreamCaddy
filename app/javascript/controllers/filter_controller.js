import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["movies", "tvshows"];


  filterContent(event) {
    const selectedType = event.target.value;

    if (selectedType === "all") {
      this.showAll();
    } else if (selectedType === "movies") {
      this.filterByType("movies");
    } else if (selectedType === "tvshows") {
      this.filterByType("tvshows");
    }
  }


  filterByGenre(event) {
    const selectedGenre = event.target.value;

    if (selectedGenre === "all") {
      this.showAll();
    } else {
      this.filterBySelectedGenre(selectedGenre);
    }
  }

  showAll() {
    this.moviesTarget.style.display = "block";
    this.tvshowsTarget.style.display = "block";
  }

  filterByType(type) {
    const movieElements = this.moviesTarget.querySelectorAll("[data-type]");
    const tvShowElements = this.tvshowsTarget.querySelectorAll("[data-type]");

    movieElements.forEach(movie => movie.style.display = "none");
    tvShowElements.forEach(show => show.style.display = "none");

    if (type === "movies") {
      movieElements.forEach(movie => movie.style.display = "block");
    } else if (type === "tvshows") {
      tvShowElements.forEach(show => show.style.display = "block");
    }
  }

  filterBySelectedGenre(genre) {
    const movieElements = this.moviesTarget.querySelectorAll("[data-genre]");
    const tvShowElements = this.tvshowsTarget.querySelectorAll("[data-genre]");

    movieElements.forEach(movie => movie.style.display = "none");
    tvShowElements.forEach(show => show.style.display = "none");

    movieElements.forEach(movie => {
      if (movie.getAttribute("data-genre") === genre) {
        movie.style.display = "block";
      }
    });
    tvShowElements.forEach(show => {
      if (show.getAttribute("data-genre") === genre) {
        show.style.display = "block";
      }
    });
  }
}
