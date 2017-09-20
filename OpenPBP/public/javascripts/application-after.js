////////////////////////////////////////////////////////////////////////////////
// Slug Generator
////////////////////////////////////////////////////////////////////////////////
$('input#title').keyup(function(){
  slug = this.value
  slug = slug.toLowerCase();
  slug = slug.replace(/\s/g, "-");
  slug = slug.replace(/[^a-zA-Z0-9\-]+/g,"");
  $('#slug').val(slug);
});
$('input#slug').keyup(function(){
  this.value = this.value.toLowerCase();
  this.value = this.value.replace(/\s/g, "-");
  this.value = this.value.replace(/[^a-zA-Z0-9\-]+/g,"");
});

////////////////////////////////////////////////////////////////////////////////
// Email Validator
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Dice Modal Opener
////////////////////////////////////////////////////////////////////////////////
$(document).ready(function () {
  $('.add-dice').click(function () {
      var modalID = $(this).data("modal-id");
      $('#' + modalID).addClass("is-active");
  });
  $('.modal-close').click(function () {
      var modalID = $(this).data("modal-id");
      $('#' + modalID).removeClass("is-active");
  });
  $('.modal-background').click(function () {
    var modalID = $(this).data("modal-id");
    $('#' + modalID).removeClass("is-active");
});
});

////////////////////////////////////////////////////////////////////////////////
// Reply Opener
////////////////////////////////////////////////////////////////////////////////
$(document).ready(function () {
  $('.reply-toggle').click(function () {
      var replyClass = $(this).data("reply-class");
      $('.' + replyClass).removeClass("is-hidden");
  });
});

////////////////////////////////////////////////////////////////////////////////
// (Automatically) Scroll to Anchor
////////////////////////////////////////////////////////////////////////////////
$(window).load(function () {
  var anchor = window.location.hash.replace("#", "");
  if (anchor) {
    function scrollToAnchor(aid){
      var aTag = $("a[name='"+ aid +"']");
      $('html,body').animate({scrollTop: aTag.offset().top},'fast');
    };
    scrollToAnchor(anchor);
  };
});
var $root = $('html, body');
$('a[href^="#"]').click(function() {
    var href = $.attr(this, 'href');
    window.location.hash = href;
    $root.animate({
      scrollTop: ($('[name="' + $.attr(this, 'href').substr(1) + '"]').offset().top - 50)
    }, 'fast');
    return false;
});

////////////////////////////////////////////////////////////////////////////////
// Sidebar Expanders
////////////////////////////////////////////////////////////////////////////////
$(document).ready(function () {
  $('#sidebar-chat-expand').click(function () {
    $('#sidebar-chat').addClass("is-active");
    getChat();
  });
});
$(document).ready(function () {
  $('#sidebar-chat-close').click(function () {
    $('#sidebar-chat').removeClass("is-active");
  });
});
$(document).ready(function () {
  $('#sidebar-notes-expand').click(function () {
    $('#sidebar-notes').addClass("is-active");
    getNotes();
  });
});
$(document).ready(function () {
  $('#sidebar-notes-close').click(function () {
    $('#sidebar-notes').removeClass("is-active");
  });
});

////////////////////////////////////////////////////////////////////////////////
// Chat Send
////////////////////////////////////////////////////////////////////////////////
$("#chat-send").click(function() {
  window.setTimeout(function(){ 
    $("#chat-input").val("");
    getChat();
  }, 100);
});

////////////////////////////////////////////////////////////////////////////////
// File Check
////////////////////////////////////////////////////////////////////////////////
$('.file-input').change(function(){
  var ext = this.value.match(/\.(.+)$/)[1];
  switch (ext) {
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      $('.file-name').text($('.file-input').prop("files")[0]['name']);
      break;
    default:
      alert('This is not an allowed file type.');
      this.value = '';
      $('#image-preview').removeClass("is-hidden");
      $('#image-current').addClass("is-hidden");
  }
});


////////////////////////////////////////////////////////////////////////////////
// Croppie for Portraits/Avatars
////////////////////////////////////////////////////////////////////////////////

$uploadCrop = $('#image-preview').croppie({
  enableExif: true,
  viewport: {
      width: 256,
      height: 256,
  },
  boundary: {
      width: 300,
      height: 300
  }
});
$('#file-input').on('change', function () { 
  var reader = new FileReader();
  $('#image-preview').removeClass("is-hidden");
  $('#image-current').addClass("is-hidden");
  reader.onload = function (e) {
    $uploadCrop.croppie('bind', {
      url: e.target.result
    }).then(function(){
      console.log('jQuery bind complete');
    });    
    }
    reader.readAsDataURL(this.files[0]);
});
$('#submit').on('click', function () {
  $uploadCrop.croppie('result', {
    type: 'canvas',
    size: 'viewport'
  }).then(function(result){
    if (result != "data:,"){
      $('#base64').val(result);
    };
  });
});

////////////////////////////////////////////////////////////////////////////////
// Croppie for Campaign Thumbnails
////////////////////////////////////////////////////////////////////////////////

// $uploadCrop = $('#image-preview').croppie({
//   enableExif: true,
//   viewport: {
//       width: 256,
//       height: 512,
//   },
//   boundary: {
//       width: 300,
//       height: 600
//   }
// });
// $('#file-input').on('change', function () { 
//   var reader = new FileReader();
//   $('#image-preview').removeClass("is-hidden");
//   $('#image-current').addClass("is-hidden");
//   reader.onload = function (e) {
//     $uploadCrop.croppie('bind', {
//       url: e.target.result
//     }).then(function(){
//       console.log('jQuery bind complete');
//     });    
//     }
//     reader.readAsDataURL(this.files[0]);
// });
// $('#submit-campaign').on('click', function () {
//   $uploadCrop.croppie('result', {
//     type: 'canvas',
//     size: 'viewport'
//   }).then(function(result){
//     if (result != "data:,"){
//       $('#base64').val(result);
//     };
//   });
// });