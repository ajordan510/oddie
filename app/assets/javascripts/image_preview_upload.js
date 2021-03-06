$(document).ready(function(){
    var preview = $(".upload-preview img");
    
    $(".file").change(function(event){
       var input = $(event.currentTarget);
       var file = input[0].files[0];
       var reader = new FileReader();
       $(".upload-preview").css("display", "block");
       reader.onload = function(e){
           image_base64 = e.target.result;
           preview.attr("src", image_base64);

       };
       $("#preview_image").height(200);
       $('#original_image').hide();
       reader.readAsDataURL(file);
    });
});