defmodule App.Recipes do
  @spec search(Keyword.t()) :: Tesla.Env.result()
  def search(opts) do
    Tesla.get(new(), "/", query: build_query(Keyword.take(opts, [:q])))
  end

  @spec new() :: Tesla.Client.t()
  def new() do
    Tesla.client(
      [
        Tesla.Middleware.Logger,
        {Tesla.Middleware.BaseUrl, "https://api.edamam.com/api/recipes/v2"},
        Tesla.Middleware.JSON
      ],
      {Tesla.Adapter.Finch, name: App.Finch, receive_timeout: :timer.seconds(60)}
    )
  end

  defp build_query(opts) do
    config = Application.fetch_env!(:app, __MODULE__)

    Keyword.merge(
      opts,
      type: "public",
      app_id: Keyword.fetch!(config, :app_id),
      app_key: Keyword.fetch!(config, :app_key)
    )
  end
end
