require 'script-runner'

describe ScriptRunner do

  before(:each) do
    @test_files = "spec/fixtures"
    @all_output = []
    @error_files = []
  end

  def scripts(*names)
    file_array("scripts", names)
  end

  def env(*names)
    file_array("env", names)
  end

  def file_array(key,names)
    names.map{ |n| File.join(@test_files, n, key) }
  end

  it "should run scripts" do
    p = ScriptRunner.run(scripts("one"), env("one")) { |output| @all_output << output }
    @all_output.should eql ["hello there custom var"]
    @error_files.length.should eql 0
  end

  it "should allow errors to be handled" do
    options = {
      :error_handler => lambda{ |p| @error_files << p},
      :log_level => :debug
    }

    p = ScriptRunner.run(scripts("one", "has_error"), env("one"), options) { |output| @all_output << output }
    @error_files.length.should eql 1
  end

  it "should call nested in alphabetical order" do
    p = ScriptRunner.run(scripts("nested"), env("one")) { |output| @all_output << output }
    @all_output.should eql ["spec/fixtures/nested/scripts/a/one.sh", "spec/fixtures/nested/scripts/one.sh"]
  end

  it "should call multiple nested in alphabetical order" do
    p = ScriptRunner.run(scripts("one", "nested_two", "nested"), env("one")) { |output| @all_output << output }
    @all_output.should eql [
      "hello there custom var",
      "spec/fixtures/nested_two/scripts/a/one.sh",
      "spec/fixtures/nested_two/scripts/one.sh",
      "spec/fixtures/nested/scripts/a/one.sh",
      "spec/fixtures/nested/scripts/one.sh"]
  end

  it "should skip non runnable files" do
     p = ScriptRunner.run(scripts("non_runnable"), env("one")) { |output| @all_output << output }
    @error_files.length.should eql 0
  end
end
