require 'spec_helper'

describe 'definition' do
  before(:all) do
    apply_recipe('define')
  end

  describe file('/tmp/created_by_definition') do
    it { should be_file }
    its(:content) { should eq("name:name,key:value,message:Hello, Itamae\n") }
  end

  describe file('/tmp/remote_file_in_definition') do
    it { should be_file }
    its(:content) { should eq("definition_example\n") }
  end

  describe file('/tmp/nested_params') do
    it { should be_file }
    its(:content) { should eq("true\n") }
  end

  describe file('/tmp/created_by_definition_2_created') do
    it { should be_file }
    its(:content) { should eq("name:created,key:value2,message:Hello, Itamae\n") }
  end

  describe file('/tmp/remote_file_in_definition_2_created') do
    it { should be_file }
    its(:content) { should eq("definition_example_2\n") }
  end

  describe file('/tmp/created_by_definition_2_not_created') do
    it { should_not exist }
  end

  describe file('/tmp/remote_file_in_definition_2_not_created') do
    it { should_not exist }
  end

  describe file('/tmp/created_by_definition_3_created') do
    it { should be_file }
    its(:content) { should eq("name:created,key:value3,message:Hello, Itamae\n") }
  end

  describe file('/tmp/remote_file_in_definition_3_created') do
    it { should be_file }
    its(:content) { should eq("definition_example_3\n") }
  end

  describe file('/tmp/created_by_definition_3_not_created') do
    it { should_not exist }
  end

  describe file('/tmp/remote_file_in_definition_3_not_created') do
    it { should_not exist }
  end
end
