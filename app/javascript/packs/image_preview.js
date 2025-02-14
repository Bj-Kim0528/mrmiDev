document.addEventListener("turbolinks:load", function() {
  const fileInput = document.getElementById('submission_image');
  const previewImage = document.getElementById('image-preview');
  
  if (fileInput) {
    fileInput.addEventListener('change', function(e) {
      const file = e.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = function(event) {
          previewImage.src = event.target.result;
          previewImage.style.display = 'block';
        };
        reader.readAsDataURL(file);
      } else {
        previewImage.style.display = 'none';
      }
    });
  }
});
