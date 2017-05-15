//= require tinymce.min

tinymce.init({
  selector: 'textarea.tinymce' ,
  menubar: false,
  statusbar: false,
  // cleanup: false,
  // browser_spellcheck: false,
  // gecko_spellcheck: false,
   allow_html_in_named_anchor: true,
   valid_elements: "*[*]",
//    extended_valid_elements: 'span',
//   valid_children : '+a[span]',
//    valid_classes: {
//   'span': 'caret'
// },
  plugins: [ 'autolink lists link anchor code' ],
  toolbar: 'undo redo | insert | styleselect | bold italic | link | code'
})
