ExUnit.start()

defmodule ExitIntegrationTest.Case do
  use ExUnit.CaseTemplate

  setup context do
    current_dir = File.cwd!
    dir = Map.get(context, :test_dir, "git_test")
    File.cd! System.tmp_dir
    File.mkdir! dir
    File.cd! dir
    on_exit fn ->
      File.cd! System.tmp_dir
      File.rm_rf "git_test"
      File.cd! current_dir
    end
    :ok
  end
end
