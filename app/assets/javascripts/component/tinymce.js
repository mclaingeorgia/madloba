//= require tinymce

var tinyMCEPreInit = {
    suffix: '',
    base: '/tinymce/',
    query: ''
};

tinymce.init({
  selector: 'textarea.tinymce' ,
  menubar: false,
  statusbar: false,
  relative_urls : false,
  branding: false,

  // browser_spellcheck: false,
  // gecko_spellcheck: false,
  allow_html_in_named_anchor: true,
  valid_elements: "*[*]",
  // content_css: [
  //   '/assets/component/toggleable_list.self.css?body=1'
  // ],
//    extended_valid_elements: 'span',
//   valid_children : '+a[span]',
//    valid_classes: {
//   'span': 'caret'
// },
  plugins: [ 'autolink lists link anchor code' ],
  toolbar: 'undo redo | insert | styleselect | bold italic | link | code',
  // skin_url: '/assets/skins/lightgray'
})

function initTinymceLimited(target) {
  var options = {
    menubar: false,
    statusbar: false,
    allow_html_in_named_anchor: true,
    valid_elements: "p, a, b, i, ul, ol, li, dl",
    plugins: [ 'autolink lists link anchor' ],
    toolbar: 'undo redo | insert | bold italic | link | numlist bullist',
    branding: false,
    // skin_url: '/assets/skins/lightgray'
  }
  if (typeof target === 'string') {
    options['selector'] = target
  }
  else {
    console.log(target)
    options['target'] = target
  }
  tinymce.init(options)
}
