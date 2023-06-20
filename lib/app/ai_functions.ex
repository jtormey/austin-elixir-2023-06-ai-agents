defmodule App.AiFunctions do
  alias App.Recipes

  def functions() do
    [
      %{
        "name" => "get_user_timezone",
        "description" => "Returns the timezone of the current user.",
        "parameters" => %{
          "type" => "object",
          "properties" => %{},
          "required" => []
        }
      },
      %{
        "name" => "get_current_time",
        "description" => "Returns the current time in ISO-8601 format.",
        "parameters" => %{
          "type" => "object",
          "properties" => %{
            "timezone" => %{
              "type" => "string",
              "description" => "A timezone string, for example: \"America/Chicago\"."
            }
          },
          "required" => ["timezone"]
        }
      },
      %{
        "name" => "search_recipes",
        "description" => "Responds with a list of recipes with ingredients, or \"No results\".",
        "parameters" => %{
          "type" => "object",
          "properties" => %{
            "query" => %{
              "type" => "string",
              "description" => "A string of search terms for querying the recipes database."
            }
          },
          "required" => ["search_query"]
        }
      }
    ]
  end

  def call_function("get_user_timezone", %{}) do
    get_user_timezone()
  end

  def call_function("get_current_time", %{"timezone" => timezone}) do
    get_current_time(timezone)
  end

  def call_function("search_recipes", %{"query" => query}) do
    search_recipes(query)
  end

  ## Implementations

  @doc """
  Returns the timezone of the current user.
  """
  def get_user_timezone() do
    "America/Chicago"
  end

  @doc """
  Returns the current time in ISO-8601 format.
  """
  def get_current_time() do
    to_string(DateTime.utc_now())
  end

  def get_current_time(timezone) do
    DateTime.utc_now()
    |> DateTime.shift_zone!(timezone)
    |> to_string()
  end

  @doc """
  Searches recipes database.
  """
  def search_recipes(query) do
    case Recipes.search(q: query) do
      {:ok, %{status: 200, body: %{"hits" => []}}} ->
        "No results."

      {:ok, %{status: 200, body: %{"hits" => hits}}} ->
        hits
        |> Enum.take(5)
        |> Enum.map_join("\n", fn %{"recipe" => recipe} ->
          """
          #{recipe["label"]}
          #{Enum.join(recipe["ingredientLines"], "\n")}
          """
        end)
    end
  end
end
