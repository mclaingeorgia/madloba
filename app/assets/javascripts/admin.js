/* global $ */
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.responsive


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
})
