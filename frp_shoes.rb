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

  @stream_one = Frappuccino::Stream.new(@plus)
  @stream_two = Frappuccino::Stream.new(@minus)

  @merged_stream = Frappuccino::Stream.merge(@stream_one, @stream_two)
  @counter = @merged_stream
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
