class DummyController < ApplicationController
  def index
    @datagrid = DataGrid::Base.new( DummyRecord.where(is_true: true), params: params, per_page: 25)
  end
end
