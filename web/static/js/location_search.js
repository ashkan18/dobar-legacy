import $ from "jquery"

export default class LocationAutoComplete {
  bindSearch(element_id, form) {
    let input = $('#' + element_id)[0]
    let options = {
      types: ['geocode']
    }
    let autocomplete = new google.maps.places.Autocomplete(input, options)
    autocomplete.addListener('place_changed', function() {
      var place = autocomplete.getPlace();
      if (!place.geometry) {
        return
      }
      $('#search_lat').val(place.geometry.location.lat())
      $('#search_lon').val(place.geometry.location.lng())
      $('#location-search-form').submit()
    })
  }
}
