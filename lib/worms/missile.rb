module Worms
  # Implements the same interface as Player, except it's a missile!

  class Missile
    attr_reader :x, :y, :vx, :vy

    # All missile instances use the same sound.
    EXPLOSION = Gosu::Sample.new("media/explosion.wav")

    def initialize(window, x, y, angle, force)
      force = 0 if force > 30 || force < 0
      # Horizontal/vertical velocity.
      @vx, @vy = Gosu::offset_x(angle, force).to_i, Gosu::offset_y(angle, force).to_i

      @window, @x, @y = window, x + @vx, y + @vy
    end

    def update
      # Movement, gravity
      @x += @vx
      @y += @vy
      @vy += 1
      # Hit anything?
      if @window.map.solid?(x, y) or @window.objects.any? { |o| o.hit_by?(self) } then
        # Create great particles.
        5.times do
          @window.objects << Particle.new(@window, x - 25 + rand(51), y - 25 + rand(51))
        end
        @window.map.blast(x, y)
        # Weeee, stereo sound!
        EXPLOSION.play_pan((1.0 * @x / WIDTH) * 2 - 1)
        return false
      else
        return true
      end
    end

    def draw
      # Just draw a small rectangle.
      Gosu::draw_rect x-2, y-2, 4, 4, Gosu::Color::BLACK
    end

    def hit_by?(missile)
      # Missiles can't be hit by other missiles!
      false
    end
  end
end
