require 'ovto'

class MyApp < Ovto::App
  class State < Ovto::State
    item :board, default: [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil],
    ]
    item :player, default: 0

    def game_over?
      return true if winner
      return true if board.all?{|row| row.all?{|cell| cell } }
      return false
    end

    def winner
      board.each do |row|
        winner = check_winner(*row)
        return winner if winner
      end
      board[0].size.times do |x|
        winner = check_winner(board[0][x], board[1][x], board[2][x])
        return winner if winner
      end
      check_winner(board[0][0], board[1][1], board[2][2]) or
        check_winner(board[0][2], board[1][1], board[2][0])
    end

    def check_winner(a, b, c)
      (a == b and b == c) ? a : nil
    end
  end

  class Actions < Ovto::Actions
    def update_board(state:, x:, y:)
      return if state.board[y][x]
      new_board = state.board.map(&:dup)
      new_board[y][x] = state.player
      new_player = 1 - state.player
      return {board: new_board, player: new_player}
    end

    def reset_game(state:)
      new_board = [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil],
      ]
      new_player = state.player and 1 - state.player
      { board: new_board, player: new_player }
    end
  end

  class MainComponent < Ovto::Component
    PLAYER_MARK = { nil => "", 0 => '〇', 1 => '×' }

    def render(state:)
      o 'div' do
        unless state.game_over?
          o "div#player" do
            "PLAYER: #{PLAYER_MARK[state.player]}"
          end
        end

        if state.game_over?
          o "div#winner" do
            "WINNER: #{PLAYER_MARK[state.winner]}"
          end
          o "a", href: "#", onclick: ->(e){ actions.reset_game } do
            "RESET"
          end
        end
        o "table#board" do
          state.board.each_with_index do |row, y|
            o "tr" do
              row.each_with_index do |cell, x|
                o "td", onclick: ->(e){ actions.update_board(x: x, y: y) unless state.game_over? } do
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
