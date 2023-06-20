defmodule App.AiFunctions do
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
      }
    ]
  end

  def call_function("get_user_timezone", %{}) do
    get_user_timezone()
  end

  def call_function("get_current_time", %{"timezone" => timezone}) do
    get_current_time(timezone)
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
end
