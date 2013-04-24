require 'frappuccino'

class Clock
  def initialize(app)
    @app = app
    @on = false
  end

  def start
    @animation ||= @app.animate do |i|
      emit(i) if @on
    end

    emit("started")

    @on = true
  end

  def stop
    emit("stopped")
    @on = false
  end
end

@app = Shoes.app :height => 175, :width => 130 do
  background black
  fill white

  @circ = oval 15, 50, 100

  @clock = Clock.new(@app)
  stream = Frappuccino::Stream.new(@clock)
  ticks = stream.select {|event| event.is_a?(Fixnum) }

  ticks.on_value do |i|
    @circ.move(15, 50 + (Math.sin(i) * 20).to_i)
  end

  start_stop = stream.select {|event| event.is_a?(String) }

  start_stop.on_value do |event|
    puts event
  end

  button "Start" do
    @clock.start
  end

  button "Stop" do
    @clock.stop
  end
end
