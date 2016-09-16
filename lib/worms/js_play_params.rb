module Worms
  class JsPlayParams
    def initialize(player, players)
      @player = player
      @players = players
      @enemies = build_enemies
    end

    def to_js_params
      {
        name: @player.name,
        enemies: @enemies,
        pos_x: @player.x,
        pos_y: @player.y,
        direction: @player.dir,
        custom_params: @player.custom_params
      }
    end

    def self.debug(params)
      p "DEBUG of #{params['name']} player FROM JS! #{params}"
    end

    private

    def build_enemies
      out = []
      @players.each do |player|
        next if player.dead || player == @player
        direction = player.x > @player.x ? 1 : -1
        out << [
          player.name,
          Gosu::distance(player.x, player.y, @player.x, @player.y) * direction,
          player.y
        ]
      end
      out
    end
  end
end
