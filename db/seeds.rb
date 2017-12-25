# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TIME_ZONES = {
  "American Samoa (-11:00)" => "-11:00",
  "International Date Line West (-11:00)" => "-11:00",
  "Midway Island (-11:00)" => "-11:00",
  "Hawaii (-10:00)" => "-10:00",
  "Alaska (-09:00)" => "-09:00",
  "Pacific Time (US & Canada) (-08:00)" => "-08:00",
  "Tijuana (-08:00)" => "-08:00",
  "Arizona (-07:00)" => "-07:00",
  "Chihuahua (-07:00)" => "-07:00",
  "Mazatlan (-07:00)" => "-07:00",
  "Mountain Time (US & Canada) (-07:00)" => "-07:00",
  "Central America (-06:00)" => "-06:00",
  "Central Time (US & Canada) (-06:00)" => "-06:00",
  "Guadalajara (-06:00)" => "-06:00",
  "Mexico City (-06:00)" => "-06:00",
  "Monterrey (-06:00)" => "-06:00",
  "Saskatchewan (-06:00)" => "-06:00",
  "Bogota (-05:00)" => "-05:00",
  "Eastern Time (US & Canada) (-05:00)" => "-05:00",
  "Indiana (East) (-05:00)" => "-05:00",
  "Lima (-05:00)" => "-05:00",
  "Quito (-05:00)" => "-05:00",
  "Atlantic Time (Canada) (-04:00)" => "-04:00",
  "Caracas (-04:00)" => "-04:00",
  "Georgetown (-04:00)" => "-04:00",
  "La Paz (-04:00)" => "-04:00",
  "Santiago (-04:00)" => "-04:00",
  "Newfoundland (-03:30)" => "-03:30",
  "Brasilia (-03:00)" => "-03:00",
  "Buenos Aires (-03:00)" => "-03:00",
  "Greenland (-03:00)" => "-03:00",
  "Montevideo (-03:00)" => "-03:00",
  "Mid-Atlantic (-02:00)" => "-02:00",
  "Azores (-01:00)" => "-01:00",
  "Cape Verde Is. (-01:00)" => "-01:00",
  "Casablanca (+00:00)" => "+00:00",
  "Dublin (+00:00)" => "+00:00",
  "Edinburgh (+00:00)" => "+00:00",
  "Lisbon (+00:00)" => "+00:00",
  "London (+00:00)" => "+00:00",
  "Monrovia (+00:00)" => "+00:00",
  "UTC (+00:00)" => "+00:00",
  "Amsterdam (+01:00)" => "+01:00",
  "Belgrade (+01:00)" => "+01:00",
  "Berlin (+01:00)" => "+01:00",
  "Bern (+01:00)" => "+01:00",
  "Bratislava (+01:00)" => "+01:00",
  "Brussels (+01:00)" => "+01:00",
  "Budapest (+01:00)" => "+01:00",
  "Copenhagen (+01:00)" => "+01:00",
  "Ljubljana (+01:00)" => "+01:00",
  "Madrid (+01:00)" => "+01:00",
  "Paris (+01:00)" => "+01:00",
  "Prague (+01:00)" => "+01:00",
  "Rome (+01:00)" => "+01:00",
  "Sarajevo (+01:00)" => "+01:00",
  "Skopje (+01:00)" => "+01:00",
  "Stockholm (+01:00)" => "+01:00",
  "Vienna (+01:00)" => "+01:00",
  "Warsaw (+01:00)" => "+01:00",
  "West Central Africa (+01:00)" => "+01:00",
  "Zagreb (+01:00)" => "+01:00",
  "Zurich (+01:00)" => "+01:00",
  "Athens (+02:00)" => "+02:00",
  "Bucharest (+02:00)" => "+02:00",
  "Cairo (+02:00)" => "+02:00",
  "Harare (+02:00)" => "+02:00",
  "Helsinki (+02:00)" => "+02:00",
  "Jerusalem (+02:00)" => "+02:00",
  "Kaliningrad (+02:00)" => "+02:00",
  "Kyiv (+02:00)" => "+02:00",
  "Pretoria (+02:00)" => "+02:00",
  "Riga (+02:00)" => "+02:00",
  "Sofia (+02:00)" => "+02:00",
  "Tallinn (+02:00)" => "+02:00",
  "Vilnius (+02:00)" => "+02:00",
  "Baghdad (+03:00)" => "+03:00",
  "Istanbul (+03:00)" => "+03:00",
  "Kuwait (+03:00)" => "+03:00",
  "Minsk (+03:00)" => "+03:00",
  "Moscow (+03:00)" => "+03:00",
  "Nairobi (+03:00)" => "+03:00",
  "Riyadh (+03:00)" => "+03:00",
  "St. Petersburg (+03:00)" => "+03:00",
  "Volgograd (+03:00)" => "+03:00",
  "Tehran (+03:30)" => "+03:30",
  "Abu Dhabi (+04:00)" => "+04:00",
  "Baku (+04:00)" => "+04:00",
  "Muscat (+04:00)" => "+04:00",
  "Samara (+04:00)" => "+04:00",
  "Tbilisi (+04:00)" => "+04:00",
  "Yerevan (+04:00)" => "+04:00",
  "Kabul (+04:30)" => "+04:30",
  "Ekaterinburg (+05:00)" => "+05:00",
  "Islamabad (+05:00)" => "+05:00",
  "Karachi (+05:00)" => "+05:00",
  "Tashkent (+05:00)" => "+05:00",
  "Chennai (+05:30)" => "+05:30",
  "Kolkata (+05:30)" => "+05:30",
  "Mumbai (+05:30)" => "+05:30",
  "New Delhi (+05:30)" => "+05:30",
  "Sri Jayawardenepura (+05:30)" => "+05:30",
  "Kathmandu (+05:45)" => "+05:45",
  "Almaty (+06:00)" => "+06:00",
  "Astana (+06:00)" => "+06:00",
  "Dhaka (+06:00)" => "+06:00",
  "Urumqi (+06:00)" => "+06:00",
  "Rangoon (+06:30)" => "+06:30",
  "Bangkok (+07:00)" => "+07:00",
  "Hanoi (+07:00)" => "+07:00",
  "Jakarta (+07:00)" => "+07:00",
  "Krasnoyarsk (+07:00)" => "+07:00",
  "Novosibirsk (+07:00)" => "+07:00",
  "Beijing (+08:00)" => "+08:00",
  "Chongqing (+08:00)" => "+08:00",
  "Hong Kong (+08:00)" => "+08:00",
  "Irkutsk (+08:00)" => "+08:00",
  "Kuala Lumpur (+08:00)" => "+08:00",
  "Perth (+08:00)" => "+08:00",
  "Singapore (+08:00)" => "+08:00",
  "Taipei (+08:00)" => "+08:00",
  "Ulaanbaatar (+08:00)" => "+08:00",
  "Osaka (+09:00)" => "+09:00",
  "Sapporo (+09:00)" => "+09:00",
  "Seoul (+09:00)" => "+09:00",
  "Tokyo (+09:00)" => "+09:00",
  "Yakutsk (+09:00)" => "+09:00",
  "Adelaide (+09:30)" => "+09:30",
  "Darwin (+09:30)" => "+09:30",
  "Brisbane (+10:00)" => "+10:00",
  "Canberra (+10:00)" => "+10:00",
  "Guam (+10:00)" => "+10:00",
  "Hobart (+10:00)" => "+10:00",
  "Melbourne (+10:00)" => "+10:00",
  "Port Moresby (+10:00)" => "+10:00",
  "Sydney (+10:00)" => "+10:00",
  "Vladivostok (+10:00)" => "+10:00",
  "Magadan (+11:00)" => "+11:00",
  "New Caledonia (+11:00)" => "+11:00",
  "Solomon Is. (+11:00)" => "+11:00",
  "Srednekolymsk (+11:00)" => "+11:00",
  "Auckland (+12:00)" => "+12:00",
  "Fiji (+12:00)" => "+12:00",
  "Kamchatka (+12:00)" => "+12:00",
  "Marshall Is. (+12:00)" => "+12:00",
  "Wellington (+12:00)" => "+12:00",
  "Chatham Is. (+12:45)" => "+12:45",
  "Nuku'alofa (+13:00)" => "+13:00",
  "Samoa (+13:00)" => "+13:00",
  "Tokelau Is."=>"+13:00"
}

TIME_ZONES.each_pair do |k,v|
  TimeZone.find_or_create_by(
    name: k,
    code: v
  )
end and 1

CITIZENSHIPS = %w{
  Norway
  Sweden
  Switzerland
  Canada
  Finland
  Denmark
  Netherlands
  Australia
  New\ Zealand
  Germany
  United\ Kingdom
  Austria
  Luxembourg
  France
  Ireland
  United\ States
  Spain
  Japan
  Portugal
  Italy
  Poland
  Singapore
  Czech\ Republic
  Hungary
  Slovenia
  South\ Korea
  Greece
  Argentina
  Croatia
  Latvia
  Brazil
  Bulgaria
  United\ Arab\ Emirates
  Uruguay
  Israel
  Chile
  South\ Africa
  Romania
  Russia
  China
  Costa\ Rica
  Dominican\ Republic
  Panama
  Mexico
  Qatar
  Peru
  Ecuador
  Belarus
  Malaysia
  Ukraine
  Colombia
  India
  Thailand
  Indonesia
  Philippines
  Guatemala
  Serbia
  Turkey
  Bolivia
  Saudi\ Arabia
  Azerbaijan
  Vietnam
  Tanzania
  Bahrain
  Sri\ Lanka
  Jordan
  Oman
  Angola
  Kazakhstan
  Ghana
  Kenya
  Morocco
  Algeria
  Myanmar
  Nigeria
  Pakistan
  Egypt
  Tunisia
  Lebanon
  Iran
}

CITIZENSHIPS.each do |c|
  Citizenship.find_or_create_by(
    name: c,
    code: c.downcase
  )
end and 1

LANGUAGES = %w{
  English
  Chinese
}

LANGUAGES.each do |c|
  Language.find_or_create_by(
    name: c,
    code: c.downcase
  )
end and 1

COUNTRIES = %w{
  United\ States
  Spain
  Russia
  China
}

['Prolific', 'Inventor Group LLC.'].each do |o|
  Organization.find_or_create_by(
    name: o,
    code: o.downcase
  )
end and 1

{
  invention: ['Inventor', 'Co-Inventor', 'Mentor', 'Patent Attorney', 'Reviewer Expert', 'Technical Illustrator'],
  global: ['God'],
  organization: ['Organization Administrator', 'Organization Member', 'Inventor LV1', 'Inventor LV2', 'Inventor LV3', 'Inventor LV4']
}.each_pair do |role_type, name|
  Role.find_or_create_by(
    name: name,
    code: name.downcase
    role_type: role_type
  )
end and 1
