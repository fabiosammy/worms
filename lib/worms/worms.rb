module Worms
  # Finally, the class that ties it all together.
  # Very straightforward implementation.

  class Worms < Gosu::Window
    attr_reader :map, :objects

    def initialize
      super WIDTH, HEIGHT

      self.caption = "Worms - Semana de TSI"

      # Texts to display in the appropriate situations.
      @player_instructions = []
      @player_won_messages = []

      # Create map!
      @map = Map.new

      # Add the players
      @player_count = 3
      raise "
        The max players is #{colors.size}.
        And you trying get #{@player_count} players on this game!
      " if @player_count > colors.size
      @players = []
      @player_count.times do |time_player|
        new_player = Player.new(self, rand(WIDTH), 40, colors[time_player])
        @players.push new_player
        @player_instructions.push new_player.instructions
        @player_won_messages.push new_player.won_message
      end
      @objects = @players.dup

      # Let any player start.
      @current_player = rand(@player_count)

      # Currently not waiting for a missile to hit something.
      @waiting = false
    end

    def draw
      # Draw the main game.
      @map.draw
      @objects.each { |o| o.draw }

      # If any text should be displayed, draw it - and add a nice black border around it
      # by drawing it four times, with a little offset in each direction.
      if not @waiting
        cur_text = @player_instructions[@current_player]
      elsif another_players_has_dead @current_player, @players
        cur_text = @player_won_messages[@current_player]
        @waiting = true
      end

      if cur_text then
        x, y = 0, 30
        cur_text.draw(x - 1, y, 0, 1, 1, Gosu::Color::BLACK)
        cur_text.draw(x + 1, y, 0, 1, 1, Gosu::Color::BLACK)
        cur_text.draw(x, y - 1, 0, 1, 1, Gosu::Color::BLACK)
        cur_text.draw(x, y + 1, 0, 1, 1, Gosu::Color::BLACK)
        cur_text.draw(x,     y, 0, 1, 1, Gosu::Color::WHITE)
      end
    end

    def update
      # if waiting for the next player's turn, continue to do so until the missile has
      # hit something.
      @waiting &&= !@objects.grep(Missile).empty?

      # Remove all objects whose update method returns false.
      @objects.reject! { |o| o.update == false }

      # If it's a player's turn, forward controls.
      if another_players_has_dead @current_player, @players
        @waiting = true
      elsif not @waiting and not @players[@current_player].dead then
        player = @players[@current_player]
        player.aim_up       if Gosu::button_down? Gosu::KbUp
        player.aim_down     if Gosu::button_down? Gosu::KbDown
        player.try_walk(-1) if Gosu::button_down? Gosu::KbLeft
        player.try_walk(+1) if Gosu::button_down? Gosu::KbRight
        player.try_jump     if Gosu::button_down? Gosu::KbReturn
      elsif @players[@current_player].dead
        @current_player = next_player @current_player
      end
    end

    def button_down(id)
      if id == Gosu::KbSpace and not @waiting and not @players[@current_player].dead then
        # Shoot! This is handled in button_down because holding space shouldn't auto-fire.
        @players[@current_player].shoot
        @current_player = next_player @current_player
        @waiting = true
      end
    end

    private

    def colors
      [:black, :white, :aqua, :red, :green, :blue, :yellow]
    end

    def next_player(current_player)
      current_player = current_player + 1
      current_player = 0 if current_player >= @player_count
      @players[current_player].dead ? next_player(current_player) : current_player
    end

    def another_players_has_dead(current_player, players)
      has_dead = true
      players.each do |player|
        has_dead = false if !player.dead && players[current_player] != player
      end
      has_dead
    end
  end
end
