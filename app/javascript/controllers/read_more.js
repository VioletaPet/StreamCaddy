document.addEventListener('DOMContentLoaded', function() {
  const readMoreButtons = document.querySelectorAll('.read-more-btn');

  readMoreButtons.forEach(button => {
    button.addEventListener('click', function() {
      const synopsisContainer = this.previousElementSibling;
      const fullText = synopsisContainer.dataset.fullText;
      const expandedText = this.dataset.expanded === 'true';

      if (expandedText) {
        const truncatedText = fullText.slice(0, 100) + '...';
        synopsisContainer.textContent = truncatedText;
        this.textContent = 'Read more';
        this.dataset.expanded = 'false';
      } else {
        synopsisContainer.textContent = fullText;
        this.textContent = 'Read less';
        this.dataset.expanded = 'true';
      }
    });
  });
});
