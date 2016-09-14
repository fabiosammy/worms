module Worms
  # Finally, the class that ties it all together.
  # Very straightforward implementation.

  class Worms < Gosu::Window
    attr_reader :map, :objects

    def initialize
      super WIDTH, HEIGHT

      self.caption = "RMagick Integration Demo"

      # Texts to display in the appropriate situations.
      @player_instructions = []
      @player_won_messages = []
      2.times do |plr|
        @player_instructions << Gosu::Image.from_text(
          "It is the #{ plr == 0 ? 'green' : 'red' } toy soldier's turn.\n" +
          "(Arrow keys to walk and aim, Return to jump, Space to shoot)",
          30, :width => width, :align => :center)
        @player_won_messages << Gosu::Image.from_text(
          "The #{ plr == 0 ? 'green' : 'red' } toy soldier has won!",
          30, :width => width, :align => :center)
      end

      # Create everything!
      @map = Map.new
      @players = [Player.new(self, 100, 40, 0xff_308000), Player.new(self, WIDTH - 100, 40, 0xff_803000)]
      @objects = @players.dup

      # Let any player start.
      @current_player = rand(2)
      # Currently not waiting for a missile to hit something.
      @waiting = false
    end

    def draw
      # Draw the main game.
      @map.draw
      @objects.each { |o| o.draw }

      # If any text should be displayed, draw it - and add a nice black border around it
      # by drawing it four times, with a little offset in each direction.

      cur_text = @player_instructions[@current_player] if not @waiting
      cur_text = @player_won_messages[1 - @current_player] if @players[@current_player].dead

      if cur_text then
        x, y = 0, 30
        cur_text.draw(x - 1, y, 0, 1, 1, 0xff_000000)
        cur_text.draw(x + 1, y, 0, 1, 1, 0xff_000000)
        cur_text.draw(x, y - 1, 0, 1, 1, 0xff_000000)
        cur_text.draw(x, y + 1, 0, 1, 1, 0xff_000000)
        cur_text.draw(x,     y, 0, 1, 1, 0xff_ffffff)
      end
    end

    def update
      # if waiting for the next player's turn, continue to do so until the missile has
      # hit something.
      @waiting &&= !@objects.grep(Missile).empty?

      # Remove all objects whose update method returns false.
      @objects.reject! { |o| o.update == false }

      # If it's a player's turn, forward controls.
      if not @waiting and not @players[@current_player].dead then
        player = @players[@current_player]
        player.aim_up       if Gosu::button_down? Gosu::KbUp
        player.aim_down     if Gosu::button_down? Gosu::KbDown
        player.try_walk(-1) if Gosu::button_down? Gosu::KbLeft
        player.try_walk(+1) if Gosu::button_down? Gosu::KbRight
        player.try_jump     if Gosu::button_down? Gosu::KbReturn
      end
    end

    def button_down(id)
      if id == Gosu::KbSpace and not @waiting and not @players[@current_player].dead then
        # Shoot! This is handled in button_down because holding space shouldn't auto-fire.
        @players[@current_player].shoot
        @current_player = 1 - @current_player
        @waiting = true
      end
    end
  end
end
