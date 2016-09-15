module Worms
  class JsPlay
    def initialize(player)
      @player = player
      @context = ExecJS.compile(File.read(@player.js_file))
    end

    def call_context_play(players)
      @context.call('play', build_params(players))
    end

    private

    def build_params(players)
      JsPlayParams.new(@player, players).to_js_params
    end
  end
end
