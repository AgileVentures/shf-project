# frozen_string_literal: true

FactoryBot.define do
  factory :events_hashes, class: Array do
    array do
      [
          {
            dinkurs_id: '26230',
            name: 'Intresselista',
            fee: '0',
            start_date: '2040-01-01'.to_date,
            description: nil,
            sing_up_url:
              'https://dinkurs.se/appliance/?event_key=LGbRBLplIUHsNJHF'
          },
          {
            dinkurs_id: '41988',
            name: 'stav',
            fee: '300',
            start_date: '2040-01-01'.to_date,
            description: 'Informationstext innan anmälningsformuläret\n\nLämna'\
                         ' denna ruta tom för att låta deltagaren komma direkt'\
                         ' till anmälningsformuläret',
            sing_up_url:
              'https://dinkurs.se/appliance/?event_key=BLQHndUsZcZHrJhR'
          }
      ]
    end
    initialize_with { array }
  end
end
