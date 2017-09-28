defmodule Flexcility.Accounts.Sessions do
  @moduledoc """
  Manage sessions and logins
  """

  alias Flexcility.Graph
  alias Flexcility.Utils
  alias Flexcility.Accounts
  alias Flexcility.Accounts.{User, Organisation}
  alias Graph.Query

  def get_user_with_role(%{email: email, subdomain: subdomain}) do
    query =
      %Query{}
      |> Query.raw("""
          MATCH (user:User {email: '#{email}'})-[rel:MEMBER]->(organisation:Organisation {subdomain: '#{subdomain}'}) RETURN user, rel, organisation
          """)

    {:ok, res} = Graph.run_query(query.string)
    [user, rel, organisation] =
      res
      |> Enum.map(fn(row)->
           [
            Utils.get_struct(row, User),
            Utils.get_rel(row),
            Utils.get_struct(row, Organisation)
          ]
         end)
      |> List.flatten

    role = %{
     name: rel.role
    }

    %{
      user: user,
      role: %{
        name: rel.role
      },
      organisation: organisation
    }

  end
end
