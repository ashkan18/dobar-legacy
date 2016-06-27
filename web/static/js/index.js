import $ from "jquery"

let locationSearch = {
  bindSearch: function() {
    let input = $('#search_location_input')[0]
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
    })
  }
}

export default locationSearch