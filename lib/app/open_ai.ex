defmodule App.OpenAi do
  @spec chat(Keyword.t()) :: Tesla.Env.result()
  def chat(opts) do
    Tesla.post(new(), "/chat/completions", %{
      "model" => Keyword.get(opts, :model, "gpt-3.5-turbo-0613"),
      "messages" => Keyword.fetch!(opts, :messages),
      "functions" => Keyword.get(opts, :functions, [])
    })
  end

  @spec new() :: Tesla.Client.t()
  def new() do
    config = Application.fetch_env!(:app, __MODULE__)

    api_key = Keyword.fetch!(config, :api_key)
    organization = Keyword.fetch!(config, :organization)

    Tesla.client(
      [
        Tesla.Middleware.Logger,
        {Tesla.Middleware.BaseUrl, "https://api.openai.com/v1"},
        Tesla.Middleware.JSON,
        {Tesla.Middleware.Headers,
         [
           {"authorization", "Bearer " <> api_key},
           {"openai-organization", organization}
         ]}
      ],
      {Tesla.Adapter.Finch, name: App.Finch, receive_timeout: :timer.seconds(60)}
    )
  end
end
