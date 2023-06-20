alias App.AiAgent
alias App.AiFunctions

start_agent = fn ->
  AiAgent.start_link(functions: AiFunctions)
end
