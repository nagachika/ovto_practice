require 'ovto'

class MyApp < Ovto::App
  class State < Ovto::State
    item :count, default: 0
  end

  class Actions < Ovto::Actions
    def increment_count(state:, num:)
      return {count: state.count + num}
    end
  end

  class MainComponent < Ovto::Component
    def render(state:)
      o 'div' do
        o 'h1', "Counter"
        o 'div', state.count

        o "input", type: "button", onclick:  ->(e){ actions.increment_count(num: 1) }, value: "+1"
        o "input", type: "button", onclick:  ->(e){ actions.increment_count(num: 3) }, value: "+3"
      end
    end
  end
end

MyApp.run(id: 'ovto')
