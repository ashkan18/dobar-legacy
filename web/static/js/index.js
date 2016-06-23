import $ from "jquery"

let locationSearch = {
  bindSearch: function() {
    let input = $('#search_term')[0]
    let autocomplete = new google.maps.places.Autocomplete(input, {});   
  }
}

export default locationSearch