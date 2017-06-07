//= require tinymce.min

tinymce.init({
  selector: 'textarea.tinymce' ,
  menubar: false,
  statusbar: false,
  relative_urls : false,

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
  toolbar: 'undo redo | insert | styleselect | bold italic | link | code'
})
