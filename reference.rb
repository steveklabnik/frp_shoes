Shoes.app :height => 150, :width => 250 do
  background rgb(240, 250, 208)

  stack :margin => 10 do
    button "+1" do
      @count += 1
      @label.replace "Current count: #@count"
    end

    button "-1" do
      @count -= 1
      @label.replace "Current count: #@count"
    end

    @count = 0

    @label = para "Current count: #@count"
  end
end
