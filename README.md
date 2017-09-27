# DataGrid, a Rails engine
A simple gem to display data in ActiveRecords in sortable and paginated tables. 

## Usage
Create a new Grid in your Controller:
```ruby
someRecordData = SomeRecord.where(some_condition: true)
options = {params: params, per_page: 25}
@grid = DataGrid::Base.new(someRecordData, options)
```
Of course, `someRecordData` can be more complex than shown above.  
Possible options are:
* `params` - the request params (required)
* `per_page` - the number of entries shown per page (defaults to 25)
* `pagination_pages_around` - the number of pages displayed in the pagination around the active page and at the ends (defaults to 2)
* `name` - name for the grid, used to differentiate different grids on one page, also added as css-class to the table and the pagination div (default: grid)

The grid can then be displayed in the view:
```
<%= 
# the grid needs the current content, to properly generate the links for the pagination,
# hence 'self' is passed as an argument here
@grid.display(self) do |g|
  # name: Displays as column header
  # attribute: the attribute of the record corresponding to this column (used for sorting)
  # html: additional attributes for the th-element
  g.column(name: 'Some Column', attribute: 'some_attribute', 
      html: { class: 'some-class', width: '100' }) do |record|
    # The result of this block will be displayed in the table cell for this record
    record.some_attribute
  end
  
  # Repeat for as many columns as necessary
  g.column(name: 'Is true?', attribute: 'truthy') do |record|
    record.truthy ? 'yes' : 'no'
  end
end
%>
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'data-grid', git: 'https://github.com/ijuice/data-grid'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install data-grid
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
