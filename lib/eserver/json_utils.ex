defmodule Eserver.JsonUtils do
  @moduledoc """
  JSON Utilities
  """

  defimpl Jason.Encoder, for: BSON.ObjectId do
    #Implementing a custom encode function
    def encode(id, options) do
      BSON.ObjectId.encode!(id)  # Converting the binary id to a string
      |> Jason.Encoder.encode(options)  # Encoding the string to JSON
    end
  end

  def normaliseMongoId(doc) do
    doc
    |> Map.put("id", doc["_id"])  # Set the id property to the value of _id
    |> Map.delete("_id")  # Delete the _id property
  end
end
