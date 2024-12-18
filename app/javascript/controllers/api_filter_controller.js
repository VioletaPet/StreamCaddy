// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {
//   static targets = ["filterDropdown", "genreDropdown", "providerLogos", "results"];

//   connect() {
//     this.selectedProviders = new Set(); // To track selected providers
//   }

//   // Handle Media Type Filter (Movies or TV Shows)
//   filterContent() {
//     const mediaType = this.filterDropdownTarget.value; // e.g., "movie", "tvshows", or "all"
//     this.fetchFilteredResults({ media_type: mediaType });
//   }

//   // Handle Genre Filter
//   filterByGenre() {
//     const genreId = this.genreDropdownTarget.value; // e.g., "28" for Action
//     this.fetchFilteredResults({ genre_id: genreId });
//   }

//   // Handle Provider Selection Toggle
//   toggleProvider(event) {
//     const providerElement = event.currentTarget;
//     const providerId = providerElement.dataset.id;

//     // Toggle the selection
//     if (this.selectedProviders.has(providerId)) {
//       this.selectedProviders.delete(providerId);
//       providerElement.classList.remove("selected"); // Add your CSS for "selected" state
//     } else {
//       this.selectedProviders.add(providerId);
//       providerElement.classList.add("selected");
//     }

//     // Fetch updated results
//     this.fetchFilteredResults({ provider_ids: Array.from(this.selectedProviders).join("|") });
//   }

//   // Fetch filtered results dynamically
//   fetchFilteredResults(filters) {
//     // Build the query string from the filters
//     const params = new URLSearchParams(filters).toString();

//     // Fetch data from the server
//     fetch(`/media_search?${params}`, {
//       headers: {
//         "Content-Type": "application/json",
//         "X-CSRF-Token": document.querySelector("[name='csrf-token']").content, // CSRF Token for Rails
//       },
//     })
//       .then((response) => response.json())
//       .then((data) => {
//         this.updateResults(data);
//       })
//       .catch((error) => console.error("Error fetching filtered results:", error));
//   }

//   // Update the DOM with the filtered results
//   updateResults(data) {
//     this.resultsTarget.innerHTML = ""; // Clear existing results

//     // Movies Section
//     if (data.movies?.length) {
//       const movieSection = document.createElement("div");
//       movieSection.innerHTML = `<h1>Movies</h1><div class="row"></div>`;
//       const movieRow = movieSection.querySelector(".row");

//       data.movies.forEach((movie) => {
//         const movieHTML = `
//           <div class="col-6 col-md-4">
//             <div class="card-poster mb-4">
//               <img src="https://image.tmdb.org/t/p/w500${movie.poster_path}"
//                    alt="${movie.title}"
//                    class="card-img-top img-fluid rounded">
//               <div class="card-body d-flex mt-3">
//                 <h5 class="card-title">${movie.title}</h5>
//               </div>
//             </div>
//           </div>`;
//         movieRow.insertAdjacentHTML("beforeend", movieHTML);
//       });

//       this.resultsTarget.appendChild(movieSection);
//     }

//     // TV Shows Section
//     if (data.tvshows?.length) {
//       const tvSection = document.createElement("div");
//       tvSection.innerHTML = `<h1>TV Shows</h1><div class="row"></div>`;
//       const tvRow = tvSection.querySelector(".row");

//       data.tvshows.forEach((show) => {
//         const tvHTML = `
//           <div class="col-6 col-md-4">
//             <div class="card-poster mb-4">
//               <img src="https://image.tmdb.org/t/p/w500${show.poster_path}"
//                    alt="${show.name}"
//                    class="card-img-top img-fluid rounded">
//               <div class="card-body d-flex mt-3">
//                 <h5 class="card-title">${show.name}</h5>
//               </div>
//             </div>
//           </div>`;
//         tvRow.insertAdjacentHTML("beforeend", tvHTML);
//       });

//       this.resultsTarget.appendChild(tvSection);
//     }
//   }
// }
