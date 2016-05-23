defmodule Dobar.Public.PlaceView do
  use Dobar.Web, :view

  def google_map_url(%Geo.Point{coordinates: {lat, lon}}, x, y) do 
    "https://maps.googleapis.com/maps/api/staticmap?center=#{lat},#{lon}&zoom=13&size=#{x}x#{y}&key=AIzaSyBCOj7b6tahJ1qR6zU8XL5xH6KcH5tyMwU"
  end
end