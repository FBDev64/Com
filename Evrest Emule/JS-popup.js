document.addEventListener('DOMContentLoaded', function() {
  var overlay = document.querySelector('.overlay');
  overlay.style.display = 'flex';

  overlay.addEventListener('click', function(event) {
      if (event.target === overlay) {
          overlay.style.display = 'none';
      }
  });
});
