defmodule Eserver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  # The @impl true here denotes that the start function is implementing a
  # callback that was defined in the Application module
  # https://hexdocs.pm/elixir/main/Module.html#module-impl
  # This will aid the compiler to warn you when a implementaion is incorrect
  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Eserver.Worker.start_link(arg)
      # {Eserver.Worker, arg}
      {
        Plug.Cowboy,
        scheme: :http,
        plug: Eserver.Router,
        options: [port: Application.get_env(:eserver, :port)]
      },
      {
        Mongo,
        [
          name: :mongo,
          url: Application.get_env(:eserver, :db_url),
          pool_size: Application.get_env(:eserver, :pool_size)
        ]
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Eserver.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
