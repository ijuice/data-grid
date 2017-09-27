require 'test_helper'

class TwoTablesTest < ActionDispatch::IntegrationTest
  def assert_tables_present
    assert_select 'table.one_grid' do
      assert_select 'th', 'Id'
      assert_select 'th', 'Name'
      assert_select 'th', 'Content'
      assert_select 'td', 60, 'There should be 20 Entries per page with two 3 columns'
    end
    assert_select 'table.data-grid.two_grid' do
      assert_select 'th', 'Id'
      assert_select 'th', 'Name'
      assert_select 'th', 'Content'
      assert_select 'td', 60, 'There should be 20 Entries per page with two 3 columns'
    end
  end

  def assert_pagination_first_page
    assert_select 'div.pagination', 1
    assert_select 'a', { count: 0, text: '<' }
    assert_select 'a', { count: 1, text: '1' }
    assert_select 'a', { count: 1, text: '2' }
    assert_select 'a', { count: 1, text: '3' }
    assert_select 'a', { count: 0, text: '4' }
    assert_select 'a', { count: 0, text: '48' }
    assert_select 'a', { count: 1, text: '49' }
    assert_select 'a', { count: 1, text: '50' }
    assert_select 'a', { count: 1, text: '>' }
  end

  def assert_pagination_second_page
    assert_select 'div.pagination', 1
    assert_select 'a', { count: 1, text: '<' }
    assert_select 'a', { count: 1, text: '1' }
    assert_select 'a', { count: 1, text: '2' }
    assert_select 'a', { count: 1, text: '3' }
    assert_select 'a', { count: 1, text: '4' }
    assert_select 'a', { count: 0, text: '5' }
    assert_select 'a', { count: 0, text: '48' }
    assert_select 'a', { count: 1, text: '49' }
    assert_select 'a', { count: 1, text: '50' }
    assert_select 'a', { count: 1, text: '>' }
  end

  def assert_pagination_last_page
    assert_select 'div.pagination', 1
    assert_select 'a', { count: 1, text: '<' }
    assert_select 'a', { count: 1, text: '1' }
    assert_select 'a', { count: 1, text: '2' }
    assert_select 'a', { count: 0, text: '3' }
    assert_select 'a', { count: 0, text: '47' }
    assert_select 'a', { count: 1, text: '48' }
    assert_select 'a', { count: 1, text: '49' }
    assert_select 'a', { count: 1, text: '50' }
    assert_select 'a', { count: 0, text: '>' }
  end

  def assert_pagination_page_twenty
    assert_select 'div.pagination', 1
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
    assert_select 'a', { count: 0, text: '48' }
    assert_select 'a', { count: 1, text: '49' }
    assert_select 'a', { count: 1, text: '50' }
    assert_select 'a', { count: 1, text: '>' }
  end

  test "pagination for page one for grid one and grid two" do
    get "/two_tables"
    assert_response :success
    assert_tables_present
    assert_select 'div.data-grid.one_grid' do
      assert_pagination_first_page
    end
    assert_select 'div.data-grid.two_grid' do
      assert_pagination_first_page
    end
  end

  test "pagination for page two for grid one and page one for grid two" do
    get "/two_tables", params: { one_grid: { page: 2 } }
    assert_response :success
    assert_tables_present
    assert_select 'div.data-grid.one_grid' do
      assert_pagination_second_page
    end
    assert_select 'div.data-grid.two_grid' do
      assert_pagination_first_page
    end
  end

  test "pagination for page two for grid one and page two for grid two" do
    get "/two_tables", params: { one_grid: { page: 2 }, two_grid: { page: 2 } }
    assert_response :success
    assert_tables_present
    assert_select 'div.data-grid.one_grid' do
      assert_pagination_second_page
    end
    assert_select 'div.data-grid.two_grid' do
      assert_pagination_second_page
    end
  end

  test "pagination for page twenty for grid one and page one for grid two" do
    get "/two_tables", params: { one_grid: { page: 20 } }
    assert_response :success
    assert_tables_present
    assert_select 'div.data-grid.one_grid' do
      assert_pagination_page_twenty
    end
    assert_select 'div.data-grid.two_grid' do
      assert_pagination_first_page
    end
  end

  test "pagination for page two for grid one and last page for grid two" do
    get "/two_tables", params: { one_grid: { page: 2 }, two_grid: { page: 50 } }
    assert_response :success
    assert_tables_present
    assert_select 'div.data-grid.one_grid' do
      assert_pagination_second_page
    end
    assert_select 'div.data-grid.two_grid' do
      assert_pagination_last_page
    end
  end

  test "pagination for last page for grid one and page one for grid two" do
    get "/two_tables", params: { one_grid: { page: 50 } }
    assert_response :success
    assert_tables_present
    assert_select 'div.data-grid.one_grid' do
      assert_pagination_last_page
    end
    assert_select 'div.data-grid.two_grid' do
      assert_pagination_first_page
    end
  end

  test "order by id asc for grid one and by id desc for grid two" do
    get "/two_tables", params: { one_grid: { order_by: 'id', order_dir: 'ASC' }, two_grid: { order_by: 'id', order_dir: 'DESC' } }
    assert_response :success
    assert_tables_present
    assert_select 'table.data-grid.one_grid' do
      assert_select 'a.asc', 'Id'
      (1..20).each do |i|
        assert_select 'td', "#{i}"
        assert_select 'td', "guy_#{i}"
        assert_select 'td', "content_#{i}"
      end
    end
    assert_select 'table.data-grid.two_grid' do
      assert_select 'a.desc', 'Id'
      (1981..2000).each do |i|
        assert_select 'td', "#{i}"
        assert_select 'td', "guy_#{i}"
        assert_select 'td', "content_#{i}"
      end
    end
  end

  test "order by id asc page two for grid one and by id desc for grid two" do
    get "/two_tables", params: { one_grid: { order_by: 'id', order_dir: 'ASC', page: 2 }, two_grid: { order_by: 'id', order_dir: 'DESC' } }
    assert_response :success
    assert_tables_present
    assert_select 'table.data-grid.one_grid' do
      assert_select 'a.asc', 'Id'
      (21..40).each do |i|
        assert_select 'td', "#{i}"
        assert_select 'td', "guy_#{i}"
        assert_select 'td', "content_#{i}"
      end
    end
    assert_select 'table.data-grid.two_grid' do
      assert_select 'a.desc', 'Id'
      (1981..2000).each do |i|
        assert_select 'td', "#{i}"
        assert_select 'td', "guy_#{i}"
        assert_select 'td', "content_#{i}"
      end
    end
  end
end
