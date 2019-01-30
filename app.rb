require 'ovto'

class MyApp < Ovto::App
  class State < Ovto::State
    item :board, default: [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil],
    ]
    item :player, default: 0
  end

  class Actions < Ovto::Actions
    def update_board(state:, x:, y:)
      new_board = state.board.map(&:dup)
      new_board[y][x] = state.player
      new_player = 1 - state.player
      return {board: new_board, player: new_player}
    end
  end

  class MainComponent < Ovto::Component
    PLAYER_MARK = { nil => "", 0 => '〇', 1 => '×' }

    def render(state:)
      o 'div' do
        o "div#player" do
          "PLAYER: #{PLAYER_MARK[state.player]}"
        end
        o "table#board" do
          state.board.each_with_index do |row, y|
            o "tr" do
              row.each_with_index do |cell, x|
                o "td", onclick: ->(e){ actions.update_board(x: x, y: y) } do
                  PLAYER_MARK[cell]
                end
              end
            end
          end
        end
      end
    end
  end
end

MyApp.run(id: 'ovto')
