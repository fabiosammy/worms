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
        last_shoot_x: @player.last_shoot_x,
        last_shoot_y: @player.last_shoot_y,
        direction: @player.dir,
        moves: @player.moves,
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
          player.y,
          player.hp
        ]
      end
      out
    end
  end
end
