document.addEventListener("DOMContentLoaded", () => {
    document.addEventListener("change", (event) => {
        let image_upload = document.querySelector('#micropost_image');
        if (image_upload && image_upload.files.length > 0) {
            const size_im_megabytes = image.upload.files[0].size / 1024 / 1024;
            if (size_im_megabytes > 5) {
                alert("Maximum file size is 5MB. Please choose a smaller file.");
                image_upload.value = "";
            }
        }
    });
});