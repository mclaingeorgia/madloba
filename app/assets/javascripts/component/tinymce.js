//= require tinymce

var tinyMCEPreInit = {
    suffix: '',
    base: '/tinymce/',
    query: ''
};

tinymce.init({
  selector: 'textarea.tinymce' ,
  menubar: false,
  branding: false,
  statusbar: false,
  valid_elements: "*[*]",
  plugins: [ 'autolink lists link anchor code autoresize' ],
  toolbar: 'undo redo | insert | styleselect | bold italic | link | code',

  allow_html_in_named_anchor: true,
  autoresize_max_height: 600,
  relative_urls : false
})

function initTinymceLimited(target) {
  var options = {
    menubar: false,
    statusbar: false,
    branding: false,
    // valid_elements: "p, a, b, i, ul, ol, li, dl",
    plugins: [ 'autolink lists link anchor autoresize media' ],
    toolbar: 'undo redo | insert | bold italic | link | numlist bullist',

    allow_html_in_named_anchor: true,
    autoresize_max_height: 600
  }
  if (typeof target === 'string') {
    options['selector'] = target
  }
  else {
    options['target'] = target
  }
  tinymce.init(options)
}
