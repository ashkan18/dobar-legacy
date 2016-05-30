defmodule Dobar.Public.PlaceView do
  use Dobar.Web, :view

  def google_static_map_url(%Geo.Point{coordinates: {lat, lon}}, x, y) do
     "https://maps.googleapis.com/maps/api/staticmap?center=#{lat},#{lon}&markers=color:blue|#{lat},#{lon}&zoom=13&size=#{x}x#{y}&key=AIzaSyBCOj7b6tahJ1qR6zU8XL5xH6KcH5tyMwU"
  end

  def google_map_url(%Geo.Point{coordinates: {lat, lon}}, x, y) do 
    "<iframe width=#{x} height=#{y} frameborder=0 style='border:0' src='https://www.google.com/maps/embed/v1/place?center=#{lat},#{lon}&zoom=13&q=#{lat},#{lon}&key=AIzaSyBCOj7b6tahJ1qR6zU8XL5xH6KcH5tyMwU' allowfullscreen></iframe>"
  end

  def full_address(place) do
    "#{place.address}, #{place.address2}, #{place.city}, #{place.state}, #{place.country}"
  end
end