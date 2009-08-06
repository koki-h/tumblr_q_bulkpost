class Parser
  attr_reader :docs
  def initialize(filename)
    file_open(filename)
    parse
  end

  def parse
    @docs=[]
    d = "" 
    prev_line = ""
    @file.each{ |line|
      d += line unless line == "\n"
      if line == "\n" && prev_line == "\n"
        @docs.push(inner_parse(d))
        d = ""
      end
      prev_line = line
    }
    @docs.push(inner_parse(d))
  rescue
    raise $!
    file_close 
  end

  def inner_parse(string)
    title  = ""
    source = ""
    quote   = ""
    lines = string.split("\n")
    lines.each { |line|
      case line
      when /^title:/
        title = $'
      when /^source:/
        source = $'
      else
        quote += line + "\n"
      end
    }
    return {
      :title    => title,
      :source   => source,
      :quote    => quote,
      :raw_data => string
    }
  end

  def file_open(filename)
    @file = open(filename)
    puts "File opened.:#{filename}"
  rescue
    file_close
    raise "No file.:#{filename}"
  end

  def file_close
    @file.close if @fp
  end
end
if __FILE__ == $0
  puts Parser.new('quote.txt').docs
  Parser.new('aaa.txt').docs
end
