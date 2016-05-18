# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dobar.Repo.insert!(%Dobar.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

for category <- ~w(mediteranian sushi chinese fast-food) do
  Dobar.Repo.insert!(%Dobar.Category{name: category})
end
