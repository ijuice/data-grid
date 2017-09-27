require "data_grid/engine"

module DataGrid
  class Base
    attr_reader :context

    def initialize(records, options)
      @records = records
      @all_records = records
      @name = 'grid'
      @name = options[:name] + '_grid' if !options['name'].nil?
      @pages_around = 2
      @pages_around = options[:pagination_pages_around] if !options[:pagination_pages_around].nil?
      initialize_params options

      @per_page = options[:per_page]
      @page = @grid_params[:page]
      @order_by = @grid_params[:order_by]
      @order_dir = @grid_params[:order_dir]
      @offset = (@page - 1) * @per_page

      @records = @records.limit(@per_page).offset(@offset)
      @records = @records.order("#{@order_by} #{@order_dir}") if !@order_by.nil?
      @selected_record = nil

      @headers = []
      @content = []
      @current_row = 0
    end

    def display(context, html_options = {}, &columns)
      @context = context
      @output = ''.html_safe
      columns.call(self)
      @records.each do |r|
        @selected_record = r
        @content[@current_row] = []
        columns.call(self)
        @current_row += 1
      end

      @output << pagination

      view = ActionView::Base.new ActionController::Base.view_paths, {}
      view.render partial: 'data_grid/table.html.erb',
                  locals: { headers: @headers, content: @content, data_grid: self, pages_around: @pages_around }
    end

    def column(options, &content)
      if (@selected_record.nil?)
        header = {}
        header[:text] = options[:name]
        header[:html] = {}
        header[:html] = options[:html] if !options[:html].nil?
        header[:attribute] = options[:attribute]
        if options.has_key?(:attribute)
          css = @order_dir.downcase if @order_by == options[:attribute]
          order_dir = @grid_params[:order_by] == options[:attribute] && @grid_params[:order_dir] == 'ASC' ? 'DESC' : 'ASC'
          header[:text] = @context.link_to(options[:name], @context.request.query_parameters.merge(
            { @name.to_sym => params({ order_by: options[:attribute], order_dir: order_dir }) }
          ), class: css)
        end
        @headers << header
        ''
      else
        @content[@current_row] << content.call(@selected_record)
        ''
      end
    end

    def pagination
      pages_total = (@all_records.except(:select).except(:group).count.to_f / @per_page).ceil
      view = ActionView::Base.new ActionController::Base.view_paths, {}
      view.render partial: 'data_grid/pagination.html.erb', locals: { page_last: pages_total, page: @page, data_grid: self, pages_around: @pages_around }
    end

    def entries_start
      @offset + 1
    end

    def entries_end
      @offset + @records.except(:select).except(:group).count
    end

    def entries_total
      @all_records.except(:select).except(:group).count.to_s
    end

    def pagination_page_link_to(text, page)
      @grid_params[:page] = page
      @context.link_to(text, @context.request.query_parameters.merge({ @name.to_sym => params({ page: page }) }))
    end

    private
    def initialize_params(options)
      @grid_params = options[:params][@name.to_sym]
      @grid_params = {} if @grid_params.nil?
      @grid_params[:page] = 1 if @grid_params[:page].nil?
      @grid_params[:page] = @grid_params[:page].to_i
      @grid_params[:order_dir] = 'ASC' if !['ASC', 'DESC'].include? @grid_params[:order_dir]
      @grid_params[:order_by] = nil if @records.first.nil? || !@records.first.attributes.keys.include?(@grid_params[:order_by])
    end

    def params(options)
      params = {}
      params[:page] = options.has_key?(:page) ? options[:page] : @grid_params[:page]
      params[:order_by] = options.has_key?(:order_by) ? options[:order_by] : @grid_params[:order_by]
      params[:order_dir] = options.has_key?(:order_dir) ? options[:order_dir] : @grid_params[:order_dir]
      params
    end
  end
end
