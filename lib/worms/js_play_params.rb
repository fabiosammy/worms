module Worms
  class JsPlayParams
    attr_reader :enemies, :pos_x, :pos_y

    def initialize(player, players)
      @player = player
      @players = players
      @enemies = build_enemies
      @pos_x = @player.x
      @pos_y = @player.y
    end

    private

    def build_enemies
      out = []
      @players.each do |player|
        next if player == @player
        out << Gosu::distance(player.x, player.y, @player.x, @player.y)
      end
      out
    end
  end
end
