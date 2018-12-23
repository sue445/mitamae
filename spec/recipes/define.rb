node.reverse_merge!({
  message: "Hello, Itamae"
})

include_recipe 'definition/example'
include_recipe 'definition/nested_params'

definition_example "name" do
  key 'value'
end

nested_params 'true'

execute "touch /tmp/trigger_for_definition_example_2"

definition_example_2 "created" do
  key     "value2"
  only_if "test -f /tmp/trigger_for_definition_example_2"
end

definition_example_2 "not_created" do
  key    "value2"
  not_if "test -f /tmp/trigger_for_definition_example_2"
end

definition_example_3 "created" do
  key    "value3"
  not_if "test -f /tmp/this_file_is_not_exists"
end

definition_example_3 "not_created" do
  key     "value3"
  only_if "test -f /tmp/this_file_is_not_exists"
end
