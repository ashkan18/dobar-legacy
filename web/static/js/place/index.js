import CityAutoComplete from '../city_search'

export default class PlaceIndexView {
  mount() {
    new CityAutoComplete().bindSearch("search_location_input", "location-search-form")
  }
}