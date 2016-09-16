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
      @time_up = false # End the time

      # Create map!
      @map = Map.new

      # Last shoot and debug occur at
      @last_debug = Gosu::milliseconds
      @last_shoot = Gosu::milliseconds

      # Add the players
      failed = []
      @player_count = 0
      js_players = File.join(ROOT_DIR, 'players/*.js')
      @players = []
      Dir.glob(js_players).each do |js_player|
        begin
          p "Loading player #{js_player}"
          new_player = Player.new(
            self,
            rand(WIDTH),
            40,
            colors[@player_count],
            File.basename(js_player, '.js'),
            js_player
          )
          @players.push new_player
          @player_instructions.push new_player.instructions
          @player_won_messages.push new_player.won_message
          @player_count += 1
          raise "
            The max players is #{colors.size}.
            And you trying get #{@player_count} players on this game!
          " if @player_count > colors.size
        rescue
          p "Failed on load #{js_player} player"
          failed << js_player
        end
      end
      raise "
        You need at least 2 players.
        Create 2 js files in players/ with a \"play\" function.
      " unless @player_count > 1
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
      if @time_up
        cur_text = game_over
      elsif not @waiting
        cur_text = @player_instructions[@current_player]
      elsif another_players_has_dead @current_player, @players
        cur_text = @player_won_messages[@current_player]
        @waiting = true
      end

      draw_time

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

      # Waiting until all players stay in the ground
      @waiting = true if Gosu::milliseconds < 2000

      # If all another player has dead, or time_up, so finish and waiting
      if @time_up or (not @wating and another_players_has_dead(@current_player, @players))
        @waiting = true
      # If it's a player's turn, forward controls.
      elsif not @waiting and not @players[@current_player].dead
        # TODO: Add the limit to the current_player do something
        player = @players[@current_player]
        player_call = player.js_play.call_context_play(@players)

        # Debug at 2 sec
        if player_call['debug'] == 'true' && (Gosu::milliseconds - @last_debug) > 1500
          JsPlayParams.debug(player_call['params'])
          @last_debug = Gosu::milliseconds
        end

        # Do play action!
        player.action_from_js player_call['action']
        if player_call['action'] == 'shoot' && (Gosu::milliseconds - @last_shoot) > 2000
          shoot!
        end
      # Skip the player if has dead
      elsif @players[@current_player].dead
        @current_player = next_player @current_player
      end
    end

    def shoot!
      if not @waiting and not @players[@current_player].dead then
        # Shoot!
        # This is handled in action because to finish round of current_player.
        @players[@current_player].shoot
        @last_shoot = Gosu::milliseconds
        @current_player = next_player @current_player
        @waiting = true
      end
    end

    private

    def colors
      [:white, :aqua, :red, :green, :blue, :yellow]
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

    def draw_time
      Gosu::Image.from_text(
        "#{ ms_to_time }", 30, align: :left
      ).draw(0, 0, 0, 1, 1, Gosu::Color::RED)
    end

    def game_over
      Gosu::Image.from_text(
        "#{ text_score }", 30, align: :center, width: WIDTH - 60
      ).draw(0, 0, 0, 1, 1, Gosu::Color::BLUE)
    end

    def text_score(score = [], text = "GAME OVER!\n")
      @players.each do |player|
        score << { name: player.name, hp: player.hp }
      end
      score.sort_by { |player| player[:hp] }.each do |player|
        text += "#{player[:name]} - #{player[:hp]} \n"
      end
      text
    end

    def ms_to_time
      seconds = (@time_up || Gosu::milliseconds) / 1000
      minutes = seconds.to_i / 60
      seconds -= minutes * 60
      if not @time_up and minutes >= GAME_TIME
        @waiting = true
        @time_up = Gosu::milliseconds
      end
      "#{format '%02d', minutes}:#{format '%02d', seconds}"
    end
  end
end
