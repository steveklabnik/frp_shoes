require 'frappuccino'

class Tab
  def push
    emit(:pushed)
  end
end

Shoes.app :height => 200, :width => 300 do
  @tab_one = Tab.new
  @tab_two = Tab.new

  @button_one = button "tab 1" do
    @tab_one.push
  end

  @button_two = button "tab 2" do
    @tab_two.push
  end

  tab_one_stream = Frappuccino::Stream.new(@tab_one)
  tab_two_stream = Frappuccino::Stream.new(@tab_two)

  tab_one_stream.on_value do |event|
    @first.show
    @second.hide
  end

  tab_two_stream.on_value do |event|
    @first.hide
    @second.show
  end

  background "#000"
  fill "#FFF"
  @first = rect 0, 30, 300, 170
  @first.show

  fill "#CCC"
  @second = rect 0, 30, 300, 170
  @second.hide
end
