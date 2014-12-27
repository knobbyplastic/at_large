LIST_OF_EVENTS = {
    'After-Dinner Speaking'   => 'ads',
    'Apologetics'             => 'apol',
    'Duo Interpretation'      => 'duo',
    'Extemporaneous'          => 'ext',
    'Humorous Interpretation' => 'hi',
    'Illustrated Oratory'     => 'io',
    'Impromptu'               => 'imp',
    'Informative Speaking'    => 'info',
    'Open Interpretation'     => 'open',
    'Persuasive Speaking'     => 'pers',
    'Thematic Interpretation' => 'ti',
    'Lincoln-Douglas Debate'  => 'ld',
    'Team-Policy Debate'      => 'tp'
}

# Number breaking for each range
# In format {range => [number in semifinal, number in final], ...}
NUMBER_ADVANCING = {
    4..4    => [0,  2],
    5..6    => [0,  3],
    7..8    => [0,  4],
    9..10   => [0,  5],
    11..12  => [0,  6],
    13..14  => [0,  7],
    15..17  => [0,  8],
    18..21  => [10, 6],
    22..25  => [12, 6],
    26..29  => [14, 8],
    30..63  => [16, 8],
    64..79  => [24, 8],
    80..95  => [28, 8],
    96..999 => [32, 8]
}