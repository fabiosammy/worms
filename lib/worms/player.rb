module Worms
  # Player class.
  # Note that applies to the whole game:
  # All objects implement an informal interface.
  # draw: Draws the object (obviously)
  # update: Moves the object etc., returns false if the object is to be deleted
  # hit_by?(missile): Returns true if an object is hit by the missile, causing
  #                   it to explode on this object.

  class Player
    # Magic numbers considered harmful! This is the height of the
    # player as used for collision detection.
    HEIGHT = 14

    attr_reader :x, :y, :dead

    def initialize(window, x, y, color)
      # Only load the images once for all instances of this class.
      @@images ||= Gosu::Image.load_tiles("media/soldier.png", 40, 50)

      @window, @x, @y, @color = window, x, y, color
      @vy = 0

      # -1: left, +1: right
      @dir = -1

      # Aiming angle.
      @angle = 90
    end

    def draw
      if dead then
        # Poor, broken soldier.
        @@images[0].draw_rot(x, y, 0, 290 * @dir, 0.5, 0.65, @dir * 0.5, 0.5, @color)
        @@images[2].draw_rot(x, y, 0, 160 * @dir, 0.95, 0.5, 0.5, @dir * 0.5, @color)
      else
        # Was moved last frame?
        if @show_walk_anim
          # Yes: Display walking animation.
          frame = Gosu::milliseconds / 200 % 2
        else
          # No: Stand around (boring).
          frame = 0
        end

        # Draw feet, then chest.
        @@images[frame].draw(x - 10 * @dir, y - 20, 0, @dir * 0.5, 0.5, @color)
        angle = @angle
        angle = 180 - angle if @dir == -1
        @@images[2].draw_rot(x, y - 5, 0, angle, 1, 0.5, 0.5, @dir * 0.5, @color)
      end
    end

    def update
      # First, assume that no walking happened this frame.
      @show_walk_anim = false

      # Gravity.
      @vy += 1

      if @vy > 1 then
        # Move upwards until hitting something.
        @vy.times do
          if @window.map.solid?(x, y + 1)
            @vy = 0
            break
          else
            @y += 1
          end
        end
      else
        # Move downwards until hitting something.
        (-@vy).times do
          if @window.map.solid?(x, y - HEIGHT - 1)
            @vy = 0
            break
          else
            @y -= 1
          end
        end
      end

      # Soldiers are never deleted (they may die, but that is a different thing).
      true
    end

    def aim_up
      @angle -= 2 unless @angle < 10
    end

    def aim_down
      @angle += 2 unless @angle > 170
    end

    def try_walk(dir)
      @show_walk_anim = true
      @dir = dir
      # First, magically move up (so soldiers can run up hills)
      2.times { @y -= 1 unless @window.map.solid?(x, y - HEIGHT - 1) }
      # Now move into the desired direction.
      @x += dir unless @window.map.solid?(x + dir, y) or
                       @window.map.solid?(x + dir, y - HEIGHT)
      # To make up for unnecessary movement upwards, sink downward again.
      2.times { @y += 1 unless @window.map.solid?(x, y + 1) }
    end

    def try_jump
      @vy = -12 if @window.map.solid?(x, y + 1)
    end

    def shoot
      @window.objects << Missile.new(@window, x + 10 * @dir, y - 10, @angle * @dir)
    end

    def hit_by? missile
      if Gosu::distance(missile.x, missile.y, x, y) < 30 then
        # Was hit :(
        @dead = true
        return true
      else
        return false
      end
    end
  end
end