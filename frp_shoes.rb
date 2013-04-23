require 'frappuccino'

class Button
  def initialize(event)
    @event = event
  end

  def push
    emit(@event)
  end
end

Shoes.app :height => 150, :width => 250 do
  background rgb(240, 250, 208)

  @plus = Button.new(:+)
  @minus = Button.new(:-)

  @stream = Frappuccino::Stream.new([@plus, @minus])

  @counter = @stream
             .map do |event|
                case event
                when :+
                  1
                when :-
                  -1
                else
                  0
                end
              end
            .inject(0) {|sum, n| sum + n }

  stack :margin => 10 do
    button "+1" do
      @plus.push
    end

    button "-1" do
      @minus.push
    end

    @label = para "Current count: #{@counter.to_i}"

    @counter.on_value do |value|
      @label.replace "Current count: #{value}"
    end
  end
end
