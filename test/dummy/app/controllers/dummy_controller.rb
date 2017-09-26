class DummyController < ApplicationController
  def index
    @datagrid = DataGrid::Base.new( DummyRecord.all, params: params, per_page: 25)
  end
end
