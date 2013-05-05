require 'spec_helper'
require 'run_test'

describe RunTest do

  it "finds files" do
    file = "my_file.rb"
    File.should_receive(:exist?).with(file).and_return(true)
    expect(RunTest.command [file]).to eq "ruby -Itest #{file}"
  end

  it "finds classes" do
    ["SomeTest", "OtherTest", "TheClass"].each do |clazz|
      test_clazz = clazz.dup
      test_clazz = "#{clazz}Test" unless clazz.end_with? "Test"
      clazz_file = test_clazz.gsub(/(?<!^)[A-Z]/) { |c| "_#{c.downcase}" }
      clazz_file = clazz_file.downcase # Remove first capital letter
      path = "path/to/#{clazz_file}.rb"
      expect_grep("^class #{test_clazz}", path)
      expect(command [clazz]).to eq "ruby -Itest #{path}"
    end
  end

  it "finds underscore names" do
    ["test_case", "test_another"].each do |test_case|
      path = "path/to/file_for_#{test_case}.rb"
      expect_grep(test_case.gsub(/_/, "[ _]"), path)
      expect(command [test_case]).to eq "ruby -Itest #{path}"
    end
  end

  it "finds string names" do
    ['"test spaces"', '"test_more"'].each do |test_case|
      file = "file_for_" << test_case.slice(1..test_case.size-2).gsub(/ /, "_")
      path = "path/to/#{file}.rb"
      expect_grep(test_case, path)
      expect(command [test_case]).to eq "ruby -Itest #{path}"
    end
  end

  it "selects the shortest file when several matches" do
    test_case = '"my test"'
    paths = ["path/to/file_one.rb", "path/to/file_2.rb"]
    expect_grep(test_case, paths.join("\n"))
    expect(command [test_case]).to eq "ruby -Itest #{paths[1]}"
  end

  it "exits when no tests are found" do
    RunTest.stub!(:puts)
    test_case = '"non_existing_test"'
    expect_grep(test_case, "")
    expect{ command [test_case] }.to raise_error
  end
end

def expect_grep(expression, return_value)
  RunTest.should_receive(:`)
         .with("grep -R \"#{expression}\" -l test")
         .and_return(return_value)
end

# Mimic ARGV as a frozen list of strings
def command(args)
  args.map { |arg| arg.freeze }
  RunTest.command(args.freeze)
end