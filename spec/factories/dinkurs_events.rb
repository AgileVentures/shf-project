# frozen_string_literal: true

FactoryBot.define do
  factory :dinkurs_events, class: Array do
    array do
      [{ 'event_id' => ['26230', { '__content__' => '26230', 'type' => 'PropertyNumber' }],
         'event_name' => { '__content__' => 'Intresselista', 'type' => 'PropertyString' },
         'event_place' => { '__content__' => 'Intresselista/Nyhetsbrev', 'type' => 'PropertyString' },
         'event_place_geometry_location' => nil,
         'event_host' => { '__content__' => 'Demo Din Kurs', 'type' => 'PropertyString' },
         'event_fee' => { '__content__' => '0', 'type' => 'PropertyNumber' },
         'event_fee_tax' => { '__content__' => '0', 'type' => 'PropertyNumber' },
         'event_pub' => { '__content__' => '2014-10-15', 'type' => 'PropertyDate' },
         'event_apply' => { '__content__' => '2015-12-31', 'type' => 'PropertyDate' },
         'event_start' => { '__content__' => '2040-01-01', 'type' => 'PropertyDate' },
         'event_stop' => { '__content__' => '2040-01-01', 'type' => 'PropertyDate' },
         'event_participant_number' => { '__content__' => '0', 'type' => 'PropertyNumber' },
         'event_participant_reserve' => { '__content__' => '0', 'type' => 'PropertyNumber' },
         'event_participants' => { '__content__' => '0', 'type' => 'PropertyNumber' },
         'event_occasions' => { '__content__' => '0', 'type' => 'PropertyNumber' },
         'event_group' => { '__content__' => '10', 'type' => 'PropertyNumber' },
         'event_position' => { '__content__' => '3', 'type' => 'PropertyNumber' },
         'event_instructor_1' => nil,
         'event_instructor_2' => nil,
         'event_instructor_3' => nil,
         'event_parking' => { '__content__' => '1', 'type' => 'PropertyNumber' },
         'event_commenttext' => nil,
         'event_ticket_info' => nil,
         'event_key' => { '__content__' => 'LGbRBLplIUHsNJHF', 'type' => 'PropertyString' },
         'event_currency_id' => { '__content__' => '1', 'type' => 'PropertyNumber' },
         'event_default_client_numbers' => nil,
         'event_url_id' => { '__content__' => 'https://dinkurs.se/appliance/?event_id=26230', 'type' => 'PropertyString' },
         'event_url_key' => { '__content__' => 'https://dinkurs.se/appliance/?event_key=LGbRBLplIUHsNJHF', 'type' => 'PropertyString' },
         'event_infotext' => nil,
         'event_completion_text' => nil,
         'event_aftertext' => nil,
         'event_event_dates' => nil },
       { 'event_id' => ['41988', { '__content__' => '41988', 'type' => 'PropertyNumber' }],
         'event_name' => { '__content__' => 'stav', 'type' => 'PropertyString' },
         'event_place' => { '__content__' => 'Stavsnäs', 'type' => 'PropertyString' },
         'event_place_geometry_location' => { '__content__' => '(59.2911887, 18.690457000000038)', 'type' => 'PropertyString' },
         'event_host' => { '__content__' => 'Demo', 'type' => 'PropertyString' },
         'event_fee' => { '__content__' => '300', 'type' => 'PropertyNumber' },
         'event_fee_tax' => { '__content__' => '0', 'type' => 'PropertyNumber' },
         'event_pub' => { '__content__' => '2016-11-14', 'type' => 'PropertyDate' },
         'event_apply' => { '__content__' => '2016-11-24', 'type' => 'PropertyDate' },
         'event_start' => { '__content__' => '2040-01-01', 'type' => 'PropertyDate' },
         'event_stop' => { '__content__' => '2040-01-01', 'type' => 'PropertyDate' },
         'event_participant_number' => { '__content__' => '12', 'type' => 'PropertyNumber' },
         'event_participant_reserve' => { '__content__' => '0', 'type' => 'PropertyNumber' },
         'event_participants' => { '__content__' => '1', 'type' => 'PropertyNumber' },
         'event_occasions' => { '__content__' => '0', 'type' => 'PropertyNumber' },
         'event_group' => { '__content__' => '10', 'type' => 'PropertyNumber' },
         'event_position' => { '__content__' => '3', 'type' => 'PropertyNumber' },
         'event_instructor_1' => nil,
         'event_instructor_2' => nil,
         'event_instructor_3' => nil,
         'event_parking' => { '__content__' => '1', 'type' => 'PropertyNumber' },
         'event_commenttext' => nil,
         'event_ticket_info' => nil,
         'event_key' => { '__content__' => 'BLQHndUsZcZHrJhR', 'type' => 'PropertyString' },
         'event_currency_id' => { '__content__' => '1', 'type' => 'PropertyNumber' },
         'event_default_client_numbers' => nil,
         'event_url_id' => { '__content__' => 'https://dinkurs.se/appliance/?event_id=41988', 'type' => 'PropertyString' },
         'event_url_key' => { '__content__' => 'https://dinkurs.se/appliance/?event_key=BLQHndUsZcZHrJhR', 'type' => 'PropertyString' },
         'event_infotext' => { '__content__' => 'Informationstext innan anmälningsformuläret\n\nLämna denna ruta tom för att låta deltagaren komma direkt till anmälningsformuläret', 'type' => 'PropertyString' },
         'event_completion_text' => nil,
         'event_aftertext' => nil,
         'event_event_dates' => nil }]
    end

    initialize_with { array }
  end
end
