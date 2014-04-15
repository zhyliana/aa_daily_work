class RPNCalculator

  attr_accessor :standard_input, :rpn_builder

  def initialize
    @standard_input = []
    create_array
    @rpn_builder = []
    rpn
  end

  def create_array
    File.open("input_file.txt").each_line do |line|
      @standard_input += line.split(" ")
    end
  end


  def add
     rpn_builder << rpn_builder.pop + rpn_builder.pop
  end

  def subtract
    fixer = rpn_builder.pop
    rpn_builder << rpn_builder.pop - fixer
  end

  def multiply
    rpn_builder << rpn_builder.pop * rpn_builder.pop
  end

  def divide
    rpn_builder << rpn_builder.pop / rpn_builder.pop
  end

  def rpn
    until standard_input.length == 0
      case standard_input.first
        when /\d+/
        rpn_builder << standard_input.shift.to_i
        when "+"
          standard_input.shift
          add
        when "-"
          standard_input.shift
          subtract
        when "*"
          standard_input.shift
          multiply
        when "/"
          standard_input.shift
          divide
        else
          "error"

      end
    end
    p rpn_builder
  end

end

if $PROGRAM_NAME == __FILE__
  RPNCalculator.new
end

