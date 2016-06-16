export var LocationSearch = {
  bindSearch: function() {
    
  }
}

let input = document.getElementById('search_term')
let autocomplete = new google.maps.places.Autocomplete(input, {}); 