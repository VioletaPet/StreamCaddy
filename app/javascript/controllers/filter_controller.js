import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["movies", "tvshows"];

filterByGenre(event) {
  const selectedGenre = event.target.value;

  const mediaCards = document.querySelectorAll("[data-genre]");


  mediaCards.forEach((card) => {
    const cardGenre = card.dataset.genre;


    if (selectedGenre === "all" || cardGenre === selectedGenre) {
      card.style.display = "block";
    } else {
      card.style.display = "none";
    }
  });
}

  filterContent(event) {
    const selectedFilter = event.target.value;

    switch (selectedFilter) {
      case "all":
        this.showAll();
        break;
      case "movies":
        this.showMovies();
        break;
      case "tvshows":
        this.showTVShows();
        break;
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
