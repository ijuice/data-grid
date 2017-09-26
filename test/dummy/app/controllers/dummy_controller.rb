class DummyController < ApplicationController
  def index
    @dummies = DummyRecord.all
    @grid = Grid::DataGrid.new @dummies, {params: params, per_page: 25}
  end
end