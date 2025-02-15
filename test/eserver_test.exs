defmodule EserverTest do
  use ExUnit.Case
  doctest Eserver

  test "greets the world" do
    assert Eserver.hello() == :world
  end
end
