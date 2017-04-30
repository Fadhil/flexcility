defmodule Flexcility.Application do
  @moduledoc """
  The Flexcility Application Service.

  The flexcility system business domain lives in this application.

  Exposes API to clients such as the `Flexcility.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      worker(Flexcility.Repo, []),
    ], strategy: :one_for_one, name: Flexcility.Supervisor)
  end
end
