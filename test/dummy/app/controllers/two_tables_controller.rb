class TwoTablesController < ApplicationController
  def index
    @table_one = DataGrid::Base.new( DummyRecord.where(is_true: true), params: params, per_page: 20, name: 'one_grid')
    @table_two = DataGrid::Base.new( DummyRecord.where(is_true: false), params: params, per_page: 20, name: 'two_grid')
  end
end
