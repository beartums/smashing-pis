module Utils
  class TableToObjectArray
  
    # given a table with defined line and column delimiters, return an array of objects, using the
    # first row as property names

    def initialize(table:, drop: 0, line_delim: "\n", column_delim: "\t")
      @table = table
      @line_delim = line_delim
      @column_delim = column_delim
      @drop = drop
    end

    def properties
      rows[0].split(@column_delim)
    end

    def rows
      @table.split(@line_delim).drop(@drop)
    end

    def objects
      props = properties
      rows.drop(1).map do |row|
        object(props, row)
      end
    end

    def object(props, values)
      hash = {}
      props.each_with_index { |p, idx| hash[p] = values[idx] }
      hash
    end
    def test_string
    end

  end
end
=begin
"Linux 5.4.20-rockchip64 (GrifRock1) \t06/26/2020 \t_aarch64_\t(4 CPU)\n\n07:56:21 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle\n07:56:21 AM  all    0.49    0.00    0.23    0.02    0.00    0.01    0.00    0.00    0.00   99.25\n07:56:21 AM    0    0.46    0.00    0.24    0.01    0.00    0.04    0.00 
0.00    0.00   99.24\n07:56:21 AM    1    0.50    0.00    0.24    0.02    0.00    0.00    0.00    0.00    0.00   99.24\n07:56:21 AM    2    0.50    0.00    0.21    0.03  
0.00    0.00    0.00    0.00    0.00   99.25\n07:56:21 AM    3    0.49    0.00    0.23    0.01    0.00    0.00    0.00    0.00    0.00   99.26\n"
=end