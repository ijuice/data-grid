require 'test_helper'

class GridIntegrationTest < ActionDispatch::IntegrationTest
  def assert_table_present
    assert_select 'table.data-grid', 1
    assert_select 'th', 'Id'
    assert_select 'th', 'Name'
    assert_select 'th', 'Content'
    assert_select 'td', 75, 'There should be 25 Entries per page with two 3 columns'
  end

  test "pagination for page one" do
    get "/dummy"
    assert_response :success
    assert_table_present
    assert_select 'ul.pagination', 1
    assert_select 'a', { count: 0, text: '<' }
    assert_select 'a', { count: 1, text: '1' }
    assert_select 'a', { count: 1, text: '2' }
    assert_select 'a', { count: 1, text: '3' }
    assert_select 'a', { count: 0, text: '4' }
    assert_select 'a', { count: 0, text: '38' }
    assert_select 'a', { count: 1, text: '39' }
    assert_select 'a', { count: 1, text: '40' }
    assert_select 'a', { count: 1, text: '>' }
  end

  test "pagination for page two" do
    get "/dummy", params: {grid: {page: 2}}
    assert_response :success
    assert_table_present
    assert_select 'ul.pagination', 1
    assert_select 'a', { count: 1, text: '<' }
    assert_select 'a', { count: 1, text: '1' }
    assert_select 'a', { count: 1, text: '2' }
    assert_select 'a', { count: 1, text: '3' }
    assert_select 'a', { count: 1, text: '4' }
    assert_select 'a', { count: 0, text: '5' }
    assert_select 'a', { count: 0, text: '38' }
    assert_select 'a', { count: 1, text: '39' }
    assert_select 'a', { count: 1, text: '40' }
    assert_select 'a', { count: 1, text: '>' }
  end

  test "pagination for page twenty" do
    get "/dummy", params: {grid: {page: 20}}
    assert_response :success
    assert_table_present
    assert_select 'ul.pagination', 1
    assert_select 'a', { count: 1, text: '<' }
    assert_select 'a', { count: 1, text: '1' }
    assert_select 'a', { count: 1, text: '2' }
    assert_select 'a', { count: 0, text: '3' }
    assert_select 'a', { count: 0, text: '17' }
    assert_select 'a', { count: 1, text: '18' }
    assert_select 'a', { count: 1, text: '19' }
    assert_select 'a', { count: 1, text: '20' }
    assert_select 'a', { count: 1, text: '21' }
    assert_select 'a', { count: 1, text: '22' }
    assert_select 'a', { count: 0, text: '23' }
    assert_select 'a', { count: 0, text: '38' }
    assert_select 'a', { count: 1, text: '39' }
    assert_select 'a', { count: 1, text: '40' }
    assert_select 'a', { count: 1, text: '>' }
  end

  test "pagination for last page" do
    get "/dummy", params: {grid: {page: 40}}
    assert_response :success
    assert_table_present
    assert_select 'ul.pagination', 1
    assert_select 'a', { count: 1, text: '<' }
    assert_select 'a', { count: 1, text: '1' }
    assert_select 'a', { count: 1, text: '2' }
    assert_select 'a', { count: 0, text: '3' }
    assert_select 'a', { count: 0, text: '37' }
    assert_select 'a', { count: 1, text: '38' }
    assert_select 'a', { count: 1, text: '39' }
    assert_select 'a', { count: 1, text: '40' }
    assert_select 'a', { count: 0, text: '>' }
  end

  test "order by id asc" do
    get "/dummy", params: {grid: {order_by: 'id', order_dir: 'ASC'}}
    assert_response :success
    assert_table_present
    assert_select 'a.asc', 'Id'
    (1..25).each do |i|
      assert_select 'td', "#{i}"
      assert_select 'td', "guy_#{i}"
      assert_select 'td', "content_#{i}"
    end
  end

  test "order by id asc page two" do
    get "/dummy", params: {grid: {order_by: 'id', order_dir: 'ASC', page: 2}}
    assert_response :success
    assert_table_present
    assert_select 'a.asc', 'Id'
    (26..50).each do |i|
      assert_select 'td', "#{i}"
      assert_select 'td', "guy_#{i}"
      assert_select 'td', "content_#{i}"
    end
  end

  test "order by id desc" do
    get "/dummy", params: {grid: {order_by: 'id', order_dir: 'DESC'}}
    assert_response :success
    assert_table_present
    assert_select 'a.desc', 'Id'
    (976..1000).each do |i|
      assert_select 'td', "#{i}"
      assert_select 'td', "guy_#{i}"
      assert_select 'td', "content_#{i}"
    end
  end
end
