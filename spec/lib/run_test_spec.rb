require 'spec_helper'
require 'run_test'

describe RunTest do

  it "finds files" do
    file = "my_file.rb"
    File.should_receive(:exist?).with(file).and_return(true)
    expect(command file).to eq "ruby -Itest #{file}"
  end

  it "finds classes" do
    ["SomeTest", "OtherTest", "TheClass"].each do |clazz|
      test_clazz = clazz.dup
      test_clazz = "#{clazz}Test" unless clazz.end_with? "Test"
      clazz_file = test_clazz.gsub(/(?<!^)[A-Z]/) { |c| "_#{c.downcase}" }
      clazz_file = clazz_file.downcase # Remove first capital letter
      path = "path/to/#{clazz_file}.rb"
      expect_grep("^class #{test_clazz}", path)
      expect(  it "selects the shortest file when several matches" do
    test_class = "SomeTest"
    paths = ["path/to/file_one.rb", "path/to/file_2.rb"]
    expect_grep("^class #{test_class}", paths.join("\n"))
    expect(command test_class).to eq "ruby -Itest #{paths[1]}"
  end

  it "finds underscore names" do
    test_case = "test_case"
    path = "path/to/file_for_test_case.rb"
    expression = "test[ _]case"
    expect_grep(expression, path)
    expected_command = "ruby -Itest #{path} -n \"#{expression}\""
    expect(command test_case).to eq expected_command
  end

  it "finds string names" do
    test_case = "test spaces"
    path = "path/to/file_for_test_spaces.rb"
    expression = "test[ _]spaces" 
    expect_grep(expression, path)
    expected_command = "ruby -Itest #{path} -n \"#{expression}\""
    expect(command test_case).to eq expected_command
  end

  it "exits when no tests are found" do
    RunTest.stub!(:puts)
    test_case = "non_existing_test"
    expect_grep(test_case.gsub(/_/, "[ _]"), "")
    expect{ command test_case }.to raise_error
  end
end

def expect_grep(expression, return_value)
  RunTest.should_receive(:`)
         .with("grep -R \"#{expression}\" -l test")
         .and_return(return_value)
end

# Mimic ARGV as a frozen list of strings
def command(target)
  RunTest.command(target.freeze)
end