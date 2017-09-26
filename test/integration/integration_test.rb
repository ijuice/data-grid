require 'test_helper'

class GridIntegrationTest < ActionDispatch::IntegrationTest
  test "most simple table" do
    get "/dummy"
    assert_response :success
    assert_select 'table.wice-grid', 1
    assert_select 'th', 'Name'
    assert_select 'td', dummy_records(:one).name
    assert_select 'th', 'Content'
    assert_select 'td', dummy_records(:one).content
  end


end