defmodule App.AiAgent do
  use GenServer

  require Logger

  alias App.OpenAi

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## API

  def chat(content) do
    GenServer.call(__MODULE__, {:chat, content}, :infinity)
  end

  ## Callbacks

  def init(opts) do
    {:ok, {[], opts}}
  end

  def handle_call({:chat, content}, _from, {messages, opts}) do
    chat_ai(build_message(:user, content), {messages, opts})
  end

  ## Private

  defp chat_ai(message, {messages, opts}) do
    messages = messages ++ [message]
    functions = Keyword.fetch!(opts, :functions)

    case OpenAi.chat(messages: messages, functions: functions.functions()) do
      {:ok, %{status: 200, body: %{"choices" => [choice | _rest]}}} ->
        case choice do
          %{"finish_reason" => "stop", "message" => message} ->
            Logger.info("stop: #{inspect(message)}")

            {:reply, {:ok, message["content"]}, {messages ++ [message], opts}}

          %{"finish_reason" => "function_call", "message" => message} ->
            Logger.info("function_call: #{inspect(message)}")

            %{"name" => name, "arguments" => args} = message["function_call"]
            response = functions.call_function(name, Jason.decode!(args))
            chat_ai(build_message(:function, name, response), {messages ++ [message], opts})
        end

      {:ok, %{status: status, body: body}} ->
        {:reply, {:error, {status, body}}, {messages, opts}}

      {:error, reason} ->
        {:reply, {:error, reason}, {messages, opts}}
    end
  end

  defp build_message(:user, content) do
    %{
      "role" => "user",
      "content" => content
    }
  end

  defp build_message(:function, name, content) do
    %{
      "role" => "function",
      "name" => name,
      "content" => content
    }
  end
end
