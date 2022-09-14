// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const letters = [...document.getElementsByClassName("card-letter")];
const bgColorsClasses = ["bg-blue", "bg-orange", "bg-pink", "bg-petunia"];

letters.forEach((letter) => {
  const bgColorSelected = bgColorsClasses[Math.floor(Math.random() * bgColorsClasses.length)];
  letter.classList.add(bgColorSelected);
});
