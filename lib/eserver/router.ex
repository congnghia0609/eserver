defmodule Eserver.Router do
  alias Eserver.JsonUtils, as: JSON

  # Bring Plug.Router module into scope
  use Plug.Router

  # Attach the Logger to log incoming requests
  plug(Plug.Logger)

  # Tell Plug to match the incoming request with the defined endpoints
  plug(:match)

  # Once there is a match, parse the response body if the content-type
  # is application/json. The order is important here, as we only want to
  # parse the body if there is a matching route. (Using the Jayson parser)
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  # Dispatch the connection to the matched handler
  plug(:dispatch)

  # Handler for Get request with "/" path
  # http://localhost:8080/
  get "/" do
    send_resp(conn, 200, "OK")
  end

  # http://localhost:8080/ping
  get "ping" do
    case Mongo.command(:mongo, ping: 1) do
      {:ok, _res} ->
        send_resp(conn, 200, "Who's there?")
      {:error, _err} ->
        send_resp(conn, 500, "Something went wrong")
    end
  end

  get "/posts" do
    posts =
      Mongo.find(:mongo, "Posts", %{}) # Find all the posts in the database
      |> Enum.map(&JSON.normaliseMongoId/1) # For each of the post normalise the id
      |> Enum.to_list() # Convert the records to a list
      |> Jason.encode!() # Encode the list to a JSON string

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, posts) # Send a 200 OK response with the posts in the body
  end

  get "/post/:id" do
    doc = Mongo.find_one(:mongo, "Posts", %{_id: BSON.ObjectId.decode!(id)})
    case doc do
      nil ->
        send_resp(conn, 404, "Not found")
      %{} ->
        post =
          JSON.normaliseMongoId(doc)
          |> Jason.encode!()
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, post)
      {:error, _} ->
        send_resp(conn, 500, "Something went wrong")
    end
  end

  post "/post" do
    case conn.body_params do
      %{"name" => name, "content" => content} ->
        case Mongo.insert_one(:mongo, "Posts", %{"name" => name, "content" => content}) do
          {:ok, user} ->
            doc = Mongo.find_one(:mongo, "Posts", %{_id: user.inserted_id})
            post =
              JSON.normaliseMongoId(doc)
              |> Jason.encode!()
            conn
              |> put_resp_content_type("application/json")
              |> send_resp(200, post)

          {:error, _} ->
            send_resp(conn, 500, "Something went wrong")
        end
      _ ->
        send_resp(conn, 400, "")
    end
  end

  put "/post/:id" do
    case Mongo.find_one_and_update(
      :mongo,
      "Posts",
      %{_id: BSON.ObjectId.decode!(id)},
      %{
        "$set":
          conn.body_params
          |> Map.take(["name", "content"])
          |> Enum.into(%{}, fn {key, value} -> {"#{key}", value} end)
      },
      return_document: :after
    ) do
      {:ok, doc} ->
        # IO.puts(doc)
        # %Mongo.FindAndModifyResult{
        #   value: %{
        #     "_id" => #BSON.ObjectId<67b1d3c3f7de9f9a139ddcb8>,
        #     "content" => "content1 update",
        #     "name" => "name1 update"
        #   },
        #   matched_count: 1,
        #   upserted_id: nil,
        #   updated_existing: true
        # }
        #
        # or
        #
        # %Mongo.FindAndModifyResult{
        #   value: nil,
        #   matched_count: 0,
        #   upserted_id: nil,
        #   updated_existing: false
        # }
        value = doc.value
        case value do
          nil ->
            send_resp(conn, 404, "Not found")
          _ ->
            post =
              JSON.normaliseMongoId(value)
              |> Jason.encode!()
            conn
              |> put_resp_content_type("application/json")
              |> send_resp(200, post)
        end
      {:error, _} ->
        send_resp(conn, 500, "Something went wrong")
    end
  end

  delete "/post/:id" do
    Mongo.delete_one!(:mongo, "Posts", %{_id: BSON.ObjectId.decode!(id)})
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{id: id}))
  end

  # Fallback handler when there was no match
  match _ do
    send_resp(conn, 404, "Not found")
  end
end
