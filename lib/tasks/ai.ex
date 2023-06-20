defmodule Mix.Tasks.Ai do
  use Mix.Task

  alias App.AiAgent
  alias App.AiFunctions

  @impl true
  def run(_args) do
    Mix.Task.run("phx.server")

    Logger.configure(level: :warn)

    Process.sleep(1000)

    {:ok, _agent_pid} = AiAgent.start_link(functions: AiFunctions)

    IO.puts("\nAI agent is ready.\n")

    ask_for_input()
  end

  def ask_for_input() do
    case IO.gets("you> ") |> String.trim() do
      "q" ->
        :ok

      "exit" ->
        :ok

      "" ->
        IO.puts("")
        ask_for_input()

      content ->
        case AiAgent.chat(content) do
          {:ok, reply} ->
            IO.puts("\nagent> #{reply}\n")
            ask_for_input()

          {:error, reason} ->
            IO.puts("\nerror> #{inspect(reason)}\n")
        end
    end
  end
end
