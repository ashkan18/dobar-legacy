let input = $('#search_term')

let options = {
  types: ['geocode']
}

autocomplete = new google.maps.places.Autocomplete(input, options);
