defmodule App.AiFunctions do
  def functions() do
    [
      %{
        "name" => "get_current_time",
        "description" => "Returns the current time in ISO-8601 format.",
        "parameters" => %{
          "type" => "object",
          "properties" => %{},
          "required" => []
        }
      }
    ]
  end

  def call_function("get_current_time", "{}") do
    get_current_time()
  end

  ## Implementations

  @doc """
  Returns the current time in ISO-8601 format.
  """
  def get_current_time() do
    to_string(DateTime.utc_now())
  end
end
