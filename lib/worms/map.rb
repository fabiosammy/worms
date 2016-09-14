module Worms
  # The class for this game's map.
  # Design:
  # * Dynamic map creation at startup, holding it as RMagick Image in @image
  # * Testing for solidity by testing @image's pixel values
  # * Drawing from a Gosu::Image instance
  # * Blasting holes into the map is implemented by drawing and erasing portions
  #   of @image, then recreating the corresponding area in the Gosu::Image

  class Map
    def initialize
      # Let's start with something simple and load the sky via RMagick.
      # Loading SVG files isn't possible with Gosu, so say wow!
      # (Seems to take a while though)
      sky = Magick::Image.read("media/landscape.svg").first
      @sky = Gosu::Image.new(sky, :tileable => true)

      # Create the map an stores the RMagick image in @image
      create_rmagick_map

      # Copy the RMagick Image to a Gosu Image (still unchanged)
      @gosu_image = Gosu::Image.new(@image, :tileable => true)
    end

    def solid? x, y
      # Map is open at the top.
      return false if y < 0
      # Map is closed on all other sides.
      return true if x < 0 or x >= WIDTH or y >= HEIGHT
      # Inside of the map, determine solidity from the map image.
      @image.pixel_color(x, y) != NULL_PIXEL
    end

    def draw
      # Sky background.
      @sky.draw 0, 0, 0
      # The landscape.
      @gosu_image.draw 0, 0, 0
    end

    # Radius of a crater.
    RADIUS = 25
    # Radius of a crater, Shadow included.
    SH_RADIUS = 45

    # Create the crater image (basically a circle shape that is used to erase
    # parts of the map) and the crater shadow image.
    CRATER_IMAGE = begin
      crater = Magick::Image.new(2 * RADIUS, 2 * RADIUS) { self.background_color = 'none' }
      gc = Magick::Draw.new
      gc.fill('black').circle(RADIUS, RADIUS, RADIUS, 0)
      gc.draw crater
      crater
    end
    CRATER_SHADOW = CRATER_IMAGE.shadow(0, 0, (SH_RADIUS - RADIUS) / 2, 1)

    def blast x, y
      # Draw the shadow (twice for more intensity), then erase a circle from the map.
      @image.composite! CRATER_SHADOW, x - SH_RADIUS, y - SH_RADIUS, Magick::AtopCompositeOp
      @image.composite! CRATER_SHADOW, x - SH_RADIUS, y - SH_RADIUS, Magick::AtopCompositeOp
      @image.composite! CRATER_IMAGE,  x - RADIUS,    y - RADIUS,    Magick::DstOutCompositeOp

      # Isolate the affected portion of the RMagick image.
      dirty_portion = @image.crop(x - SH_RADIUS, y - SH_RADIUS, SH_RADIUS * 2, SH_RADIUS * 2)
      # Overwrite this part of the Gosu image. If the crater begins outside of the map, still
      # just update the inner part.
      @gosu_image.insert dirty_portion, [x - SH_RADIUS, 0].max, [y - SH_RADIUS, 0].max
    end

    private

    def create_rmagick_map
      # This is the one large RMagick image that represents the map.
      @image = Magick::Image.new(WIDTH, HEIGHT) { self.background_color = 'none' }

      # Set up a Draw object that fills with an earth texture.
      earth = Magick::Image.read('media/earth.png').first.resize(1.5)
      gc = Magick::Draw.new
      gc.pattern('earth', 0, 0, earth.columns, earth.rows) { gc.composite(0, 0, 0, 0, earth) }
      gc.fill('earth')
      gc.stroke('#603000').stroke_width(1.5)
      # Draw a smooth bezier island onto the map!
      polypoints = [0, HEIGHT]
      0.upto(8) do |x|
        polypoints += [x * 100, HEIGHT * 0.2 + rand(HEIGHT * 0.8)]
      end
      polypoints += [WIDTH, HEIGHT]
      gc.bezier(*polypoints)
      gc.draw(@image)

      # Create a bright-dark gradient fill, an image from it and change the map's
      # brightness with it.
      fill = Magick::GradientFill.new(0, HEIGHT * 0.4, WIDTH, HEIGHT * 0.4, '#fff', '#666')
      gradient = Magick::Image.new(WIDTH, HEIGHT, fill)
      gradient = @image.composite(gradient, 0, 0, Magick::InCompositeOp)
      @image.composite!(gradient, 0, 0, Magick::MultiplyCompositeOp)

      # Finally, place the star in the middle of the map, just onto the ground.
      star = Magick::Image.read('media/large_star.png').first
      star_y = 0
      star_y += 20 until solid?(WIDTH / 2, star_y)
      @image.composite!(star, (WIDTH - star.columns) / 2, star_y - star.rows * 0.85,
        Magick::DstOverCompositeOp)
    end
  end
end
