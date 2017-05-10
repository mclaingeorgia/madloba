/* global $ */
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.responsive
//= require tinymce.min


$(document).ready(function(){
  $('.datatable').DataTable({
    language: {
        search: "_INPUT_",
        searchPlaceholder: "Search",
        lengthMenu: "_MENU_ Records Per Page"
    },
    autoWidth: false,
    responsive: true,
    dom: '<".datatable-filters"fl>rt<"datatable-pagination"p>',
    columnDefs: [
      { targets: 'sorting_disabled', orderable: false }
    ]
  })
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
})
