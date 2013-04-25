require 'spec_helper'
require 'run_test'

describe RunTest do
  it "understands files" do
    expect(RunTest.command ["my_file.rb"]).to eq "my_file.rb"
  end
end