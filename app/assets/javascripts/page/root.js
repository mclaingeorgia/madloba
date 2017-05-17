//= require component/loader
//= require component/rator
//= require component/favoritor
//= require component/services
//= require component/filter
//= require component/place_card

pollution.components.map.init('places_map', { zoom: 8, type: 'coordinates', locate: true })
pollution.components.filter.init()
