require IEx
defmodule Dobar.PlaceImage do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)
  @acl :public_read

  # Whitelist file extensions:
  def validate({file, _}) do   
    file_extension = file.file_name |> Path.extname |> String.downcase
    Enum.member?(@extension_whitelist, file_extension)
  end

  #Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-thumbnail 250x250^ -gravity center -extent 250x250"}
  end

  # Override the persisted filenames:
  def filename(version, {_file, scope}) do
    "#{version}_#{scope.user_id}_#{:os.system_time(:seconds)}"
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "uploads/places/#{scope.place_id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(version, _scope) do
    "/images/places/default_#{version}.png"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  def s3_object_headers(_version, {file, _scope}) do
    [content_type: Plug.MIME.path(file.file_name)]
  end
end
