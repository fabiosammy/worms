module Worms
  # Very minimal object that just draws a fading particle.

  class Particle
    def initialize(window, x, y)
      # All Particle instances use the same image
      @@image ||= Gosu::Image.new('media/smoke.png')

      @x, @y = x, y
      @color = Gosu::Color.new(255, 255, 255, 255)
    end

    def update
      @y -= 5
      @x = @x - 1 + rand(3)
      @color.alpha -= 5

      # Remove if faded completely.
      @color.alpha > 0
    end

    def draw
      @@image.draw(@x - 25, @y - 25, 0, 1, 1, @color)
    end

    def hit_by?(missile)
      # Smoke can't be hit!
      false
    end
  end
end
