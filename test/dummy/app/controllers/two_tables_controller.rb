class TwoTablesController < ApplicationController
  def index
    @table_one = DataGrid::Base.new( DummyRecord.where(is_true: true), params: params, per_page: 20, name: 'one')
    @table_two = DataGrid::Base.new( DummyRecord.where(is_true: false), params: params, per_page: 20, name: 'two')
  end
end
