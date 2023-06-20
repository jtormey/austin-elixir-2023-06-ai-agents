defmodule Mix.Tasks.Ai do
  use Mix.Task

  alias App.AiAgent
  alias App.AiFunctions

  @impl true
  def run(_args) do
    Mix.Task.run("app.start")

    Logger.configure(level: :warn)

    {:ok, _agent_pid} = AiAgent.start_link(functions: AiFunctions)

    IO.puts("")
    IO.puts("AI agent is ready.\n")

    ask_for_input()
  end

  def ask_for_input() do
    case IO.gets("you> ") |> String.trim() do
      "q" ->
        :ok

      "exit" ->
        :ok

      content ->
        case AiAgent.chat(content) do
          {:ok, reply} ->
            IO.puts("agent> #{reply}")
            ask_for_input()

          {:error, reason} ->
            IO.puts("error> #{inspect(reason)}")
        end
    end
  end
end
