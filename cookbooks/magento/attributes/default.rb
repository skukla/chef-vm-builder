#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Convert region IDs to their state or province
def get_locale(value)
    regions = [{postal_code: "AL", value: "Alabama"}, {postal_code: "AK", value: "Alaska"}, {postal_code: "AS", value: "American Samoa"}, {postal_code: "AZ", value: "Arizona"}, {postal_code: "AR", value: "Arkansas"}, {postal_code: "AE", value: "Armed Forces Africa"}, {postal_code: "AA", value: "Armed Forces Americas"}, {postal_code: "AE", value: "Armed Forces Canada"}, {postal_code: "AE", value: "Armed Forces Europe"}, {postal_code: "AE", value: "Armed Forces Middle East"}, {postal_code: "AP", value: "Armed Forces Pacific"}, {postal_code: "CA", value: "California"}, {postal_code: "CO", value: "Colorado"} ,{postal_code: "CT", value: "Connecticut"}, {postal_code: "DE", value: "Delaware"}, {postal_code: "DC", value: "District of Columbia"}, {postal_code: "FM", value: "Federated States Of Micronesia"}, {postal_code: "FL", value: "Florida"}, {postal_code: "GA", value: "Georgia"}, {postal_code: "GU", value: "Guam"}, {postal_code: "HI", value: "Hawaii"}, {postal_code: "ID", value: "Idaho"}, {postal_code: "IL", value: "Illinois"}, {postal_code: "IN", value: "Indiana"}, {postal_code: "IA", value: "Iowa"}, {postal_code: "KS", value: "Kansas"}, {postal_code: "KY", value: "Kentucky"}, {postal_code: "LA", value: "Louisiana"}, {postal_code: "ME", value: "Maine"}, {postal_code: "MH", value: "Marshall Islands"}, {postal_code: "MD", value: "Maryland"}, {postal_code: "MA", value: "Massachusetts"}, {postal_code: "MI", value: "Michigan"}, {postal_code: "MN", value: "Minnesota"} ,{postal_code: "MS", value: "Mississippi"}, {postal_code: "MO", value: "Missouri"}, {postal_code: "MT", value: "Montana"}, {postal_code: "NE", value: "Nebraska"}, {postal_code: "NV", value: "Nevada"}, {postal_code: "NH", value: "New Hampshire"}, {postal_code: "NJ", value: "New Jersey"}, {postal_code: "NM", value: "New Mexico"}, {postal_code: "NY", value: "New York"}, {postal_code: "NC", value: "North Carolina"}, {postal_code: "ND", value: "North Dakota"} ,{postal_code: "MP", value: "Northern Mariana Islands"}, {postal_code: "OH", value: "Ohio"}, {postal_code: "OK", value: "Oklahoma"}, {postal_code: "OR", value: "Oregon"}, {postal_code: "PW", value: "Palau"}, {postal_code: "PA", value: "Pennsylvania"}, {postal_code: "PR", value: "Puerto Rico"}, {postal_code: "RI", value: "Rhode Island"}, {postal_code: "SC", value: "South Carolina"} ,{postal_code: "SD", value: "South Dakota"}, {postal_code: "TN", value: "Tennessee"}, {postal_code: "TX", value: "Texas"}, {postal_code: "UT", value: "Utah"}, {postal_code: "VT", value: "Vermont"}, {postal_code: "VI", value: "Virgin Islands"}, {postal_code: "VA", value: "Virginia"}, {postal_code: "WA", value: "Washington"}, {postal_code: "WV", value: "West Virginia"}, {postal_code: "WI", value: "Wisconsin"}, {postal_code: "WY", value: "Wyoming"}
    ]
    countries = [{postal_code: "AF", value: "Afghanistan"}, {postal_code: "AX", value: "Åland Islands"}, {postal_code: "AL", value: "Albania"}, {postal_code: "DZ", value: "Algeria"}, {postal_code: "AS", value: "American Samoa"}, {postal_code: "AD", value: "Andorra"}, {postal_code: "AO", value: "Angola"}, {postal_code: "AI", value: "Anguilla"}, {postal_code: "AQ", value: "Antarctica"}, {postal_code: "AG", value: "Antigua &amp; Barbuda"}, {postal_code: "AR", value: "Argentina"}, {postal_code: "AM", value: "Armenia"}, {postal_code: "AW", value: "Aruba"}, {postal_code: "AU", value: "Australia"}, {postal_code: "AT", value: "Austria"}, {postal_code: "AZ", value: "Azerbaijan"}, {postal_code: "BS", value: "Bahamas"}, {postal_code: "BH", value: "Bahrain"}, {postal_code: "BD", value: "Bangladesh"}, {postal_code: "BB", value: "Barbados"}, {postal_code: "BY", value: "Belarus"}, {postal_code: "BE", value: "Belgium"}, {postal_code: "BZ", value: "Belize"}, {postal_code: "BJ", value: "Benin"}, {postal_code: "BM", value: "Bermuda"}, {postal_code: "BT", value: "Bhutan"}, {postal_code: "BO", value: "Bolivia"}, {postal_code: "BA", value: "Bosnia &amp; Herzegovina"}, {postal_code: "BW", value: "Botswana"}, {postal_code: "BV", value: "Bouvet Island"}, {postal_code: "BR", value: "Brazil"}, {postal_code: "IO", value: "British Indian Ocean Territory"}, {postal_code: "VG", value: "British Virgin Islands"}, {postal_code: "BN", value: "Brunei"}, {postal_code: "BG", value: "Bulgaria"}, {postal_code: "BF", value: "Burkina Faso"}, {postal_code: "BI", value: "Burundi"}, {postal_code: "KH", value: "Cambodia"}, {postal_code: "CM", value: "Cameroon"}, {postal_code: "CA", value: "Canada"}, {postal_code: "CV", value: "Cape Verde"}, {postal_code: "BQ", value: "Caribbean Netherlands"}, {postal_code: "KY", value: "Cayman Islands"}, {postal_code: "CF", value: "Central African Republic"}, {postal_code: "TD", value: "Chad"}, {postal_code: "CL", value: "Chile"}, {postal_code: "CN", value: "China"}, {postal_code: "CX", value: "Christmas Island"}, {postal_code: "CC", value: "Cocos (Keeling) Islands"}, {postal_code: "CO", value: "Colombia"}, {postal_code: "KM", value: "Comoros"}, {postal_code: "CG", value: "Congo - Brazzaville"}, {postal_code: "CD", value: "Congo - Kinshasa"}, {postal_code: "CK", value: "Cook Islands"}, {postal_code: "CR", value: "Costa Rica"}, {postal_code: "CI", value: "Côte d’Ivoire"}, {postal_code: "HR", value: "Croatia"}, {postal_code: "CU", value: "Cuba"}, {postal_code: "CW", value: "Curaçao"}, {postal_code: "CY", value: "Cyprus"}, {postal_code: "CZ", value: "Czechia"}, {postal_code: "DK", value: "Denmark"}, {postal_code: "DJ", value: "Djibouti"}, {postal_code: "DM", value: "Dominica"}, {postal_code: "DO", value: "Dominican Republic"}, {postal_code: "EC", value: "Ecuador"}, {postal_code: "EG", value: "Egypt"}, {postal_code: "SV", value: "El Salvador"}, {postal_code: "GQ", value: "Equatorial Guinea"}, {postal_code: "ER", value: "Eritrea"}, {postal_code: "EE", value: "Estonia"}, {postal_code: "SZ", value: "Eswatini"}, {postal_code: "ET", value: "Ethiopia"}, {postal_code: "FK", value: "Falkland Islands"}, {postal_code: "FO", value: "Faroe Islands"}, {postal_code: "FJ", value: "Fiji"}, {postal_code: "FI", value: "Finland"}, {postal_code: "FR", value: "France"}, {postal_code: "GF", value: "French Guiana"}, {postal_code: "PF", value: "French Polynesia"}, {postal_code: "TF", value: "French Southern Territories"}, {postal_code: "GA", value: "Gabon"}, {postal_code: "GM", value: "Gambia"}, {postal_code: "GE", value: "Georgia"}, {postal_code: "DE", value: "Germany"}, {postal_code: "GH", value: "Ghana"}, {postal_code: "GI", value: "Gibraltar"}, {postal_code: "GR", value: "Greece"}, {postal_code: "GL", value: "Greenland"}, {postal_code: "GD", value: "Grenada"}, {postal_code: "GP", value: "Guadeloupe"}, {postal_code: "GU", value: "Guam"}, {postal_code: "GT", value: "Guatemala"}, {postal_code: "GG", value: "Guernsey"}, {postal_code: "GN", value: "Guinea"}, {postal_code: "GW", value: "Guinea-Bissau"}, {postal_code: "GY", value: "Guyana"}, {postal_code: "HT", value: "Haiti"}, {postal_code: "HM", value: "Heard &amp; McDonald Islands"}, {postal_code: "HN", value: "Honduras"}, {postal_code: "HK", value: "Hong Kong SAR China"}, {postal_code: "HU", value: "Hungary"}, {postal_code: "IS", value: "Iceland"}, {postal_code: "IN", value: "India"}, {postal_code: "ID", value: "Indonesia"}, {postal_code: "IR", value: "Iran"}, {postal_code: "IQ", value: "Iraq"}, {postal_code: "IE", value: "Ireland"}, {postal_code: "IM", value: "Isle of Man"}, {postal_code: "IL", value: "Israel"}, {postal_code: "IT", value: "Italy"}, {postal_code: "JM", value: "Jamaica"}, {postal_code: "JP", value: "Japan"}, {postal_code: "JE", value: "Jersey"}, {postal_code: "JO", value: "Jordan"}, {postal_code: "KZ", value: "Kazakhstan"}, {postal_code: "KE", value: "Kenya"}, {postal_code: "KI", value: "Kiribati"}, {postal_code: "XK", value: "Kosovo"}, {postal_code: "KW", value: "Kuwait"}, {postal_code: "KG", value: "Kyrgyzstan"}, {postal_code: "LA", value: "Laos"}, {postal_code: "LV", value: "Latvia"}, {postal_code: "LB", value: "Lebanon"}, {postal_code: "LS", value: "Lesotho"}, {postal_code: "LR", value: "Liberia"}, {postal_code: "LY", value: "Libya"}, {postal_code: "LI", value: "Liechtenstein"}, {postal_code: "LT", value: "Lithuania"}, {postal_code: "LU", value: "Luxembourg"}, {postal_code: "MO", value: "Macao SAR China"}, {postal_code: "MG", value: "Madagascar"}, {postal_code: "MW", value: "Malawi"}, {postal_code: "MY", value: "Malaysia"}, {postal_code: "MV", value: "Maldives"}, {postal_code: "ML", value: "Mali"}, {postal_code: "MT", value: "Malta"}, {postal_code: "MH", value: "Marshall Islands"}, {postal_code: "MQ", value: "Martinique"}, {postal_code: "MR", value: "Mauritania"}, {postal_code: "MU", value: "Mauritius"}, {postal_code: "YT", value: "Mayotte"}, {postal_code: "MX", value: "Mexico"}, {postal_code: "FM", value: "Micronesia"}, {postal_code: "MD", value: "Moldova"}, {postal_code: "MC", value: "Monaco"}, {postal_code: "MN", value: "Mongolia"}, {postal_code: "ME", value: "Montenegro"}, {postal_code: "MS", value: "Montserrat"}, {postal_code: "MA", value: "Morocco"}, {postal_code: "MZ", value: "Mozambique"}, {postal_code: "MM", value: "Myanmar (Burma)"}, {postal_code: "NA", value: "Namibia"}, {postal_code: "NR", value: "Nauru"}, {postal_code: "NP", value: "Nepal"}, {postal_code: "NL", value: "Netherlands"}, {postal_code: "NC", value: "New Caledonia"}, {postal_code: "NZ", value: "New Zealand"}, {postal_code: "NI", value: "Nicaragua"}, {postal_code: "NE", value: "Niger"}, {postal_code: "NG", value: "Nigeria"}, {postal_code: "NU", value: "Niue"}, {postal_code: "NF", value: "Norfolk Island"}, {postal_code: "MP", value: "Northern Mariana Islands"}, {postal_code: "KP", value: "North Korea"}, {postal_code: "MK", value: "North Macedonia"}, {postal_code: "NO", value: "Norway"}, {postal_code: "OM", value: "Oman"}, {postal_code: "PK", value: "Pakistan"}, {postal_code: "PW", value: "Palau"}, {postal_code: "PS", value: "Palestinian Territories"}, {postal_code: "PA", value: "Panama"}, {postal_code: "PG", value: "Papua New Guinea"}, {postal_code: "PY", value: "Paraguay"}, {postal_code: "PE", value: "Peru"}, {postal_code: "PH", value: "Philippines"}, {postal_code: "PN", value: "Pitcairn Islands"}, {postal_code: "PL", value: "Poland"}, {postal_code: "PT", value: "Portugal"}, {postal_code: "QA", value: "Qatar"}, {postal_code: "RE", value: "Réunion"}, {postal_code: "RO", value: "Romania"}, {postal_code: "RU", value: "Russia"}, {postal_code: "RW", value: "Rwanda"}, {postal_code: "WS", value: "Samoa"}, {postal_code: "SM", value: "San Marino"}, {postal_code: "ST", value: "São Tomé &amp; Príncipe"}, {postal_code: "SA", value: "Saudi Arabia"}, {postal_code: "SN", value: "Senegal"}, {postal_code: "RS", value: "Serbia"}, {postal_code: "SC", value: "Seychelles"}, {postal_code: "SL", value: "Sierra Leone"}, {postal_code: "SG", value: "Singapore"}, {postal_code: "SX", value: "Sint Maarten"}, {postal_code: "SK", value: "Slovakia"}, {postal_code: "SI", value: "Slovenia"}, {postal_code: "SB", value: "Solomon Islands"}, {postal_code: "SO", value: "Somalia"}, {postal_code: "ZA", value: "South Africa"}, {postal_code: "GS", value: "South Georgia &amp; South Sandwich Islands"}, {postal_code: "KR", value: "South Korea"}, {postal_code: "ES", value: "Spain"}, {postal_code: "LK", value: "Sri Lanka"}, {postal_code: "BL", value: "St. Barthélemy"}, {postal_code: "SH", value: "St. Helena"}, {postal_code: "KN", value: "St. Kitts &amp; Nevis"}, {postal_code: "LC", value: "St. Lucia"}, {postal_code: "MF", value: "St. Martin"}, {postal_code: "PM", value: "St. Pierre &amp; Miquelon"}, {postal_code: "VC", value: "St. Vincent &amp; Grenadines"}, {postal_code: "SD", value: "Sudan"}, {postal_code: "SR", value: "Suriname"}, {postal_code: "SJ", value: "Svalbard &amp; Jan Mayen"}, {postal_code: "SE", value: "Sweden"}, {postal_code: "CH", value: "Switzerland"}, {postal_code: "SY", value: "Syria"}, {postal_code: "TW", value: "Taiwan, Province of China"}, {postal_code: "TJ", value: "Tajikistan"}, {postal_code: "TZ", value: "Tanzania"}, {postal_code: "TH", value: "Thailand"}, {postal_code: "TL", value: "Timor-Leste"}, {postal_code: "TG", value: "Togo"}, {postal_code: "TK", value: "Tokelau"}, {postal_code: "TO", value: "Tonga"}, {postal_code: "TT", value: "Trinidad &amp; Tobago"}, {postal_code: "TN", value: "Tunisia"}, {postal_code: "TR", value: "Turkey"}, {postal_code: "TM", value: "Turkmenistan"}, {postal_code: "TC", value: "Turks &amp; Caicos Islands"}, {postal_code: "TV", value: "Tuvalu"}, {postal_code: "UG", value: "Uganda"}, {postal_code: "UA", value: "Ukraine"}, {postal_code: "AE", value: "United Arab Emirates"}, {postal_code: "GB", value: "United Kingdom"}, {postal_code: "US", value: "United States"}, {postal_code: "UY", value: "Uruguay"}, {postal_code: "UM", value: "U.S. Outlying Islands"}, {postal_code: "VI", value: "U.S. Virgin Islands"}, {postal_code: "UZ", value: "Uzbekistan"}, {postal_code: "VU", value: "Vanuatu"}, {postal_code: "VA", value: "Vatican City"}, {postal_code: "VE", value: "Venezuela"}, {postal_code: "VN", value: "Vietnam"}, {postal_code: "WF", value: "Wallis &amp; Futuna"}, {postal_code: "EH", value: "Western Sahara"}, {postal_code: "YE", value: "Yemen"}, {postal_code: "ZM", value: "Zambia"}, {postal_code: "ZW", value: "Zimbabwe"}
    ]
    regions.each_with_index do |region, index|
        if value == region[:value] || value == region[:postal_code]
            return index + 1
        end
    end
    countries.each_with_index do |country, index|
        if value == country[:value] || value == country[:postal_code]
            return country[:postal_code]
        end
    end
    Chef::Log.debug("One your state or country abbreviations is incorrect in config.json")
    return nil
end

default[:application][:installation][:conf_options] = 
{
    path: "general/store_information/name",
    value: node[:custom_demo][:configuration][:store_information][:name][:value],
    scope: node[:custom_demo][:configuration][:store_information][:name][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:name][:scope_code]
},
{
    path: "general/store_information/phone",
    value: node[:custom_demo][:configuration][:store_information][:phone][:value],
    scope: node[:custom_demo][:configuration][:store_information][:phone][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:phone][:scope_code]
},
{
    path: "general/store_information/hours",
    value: node[:custom_demo][:configuration][:store_information][:hours][:value],
    scope: node[:custom_demo][:configuration][:store_information][:hours][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:hours][:scope_code]
},
{
    path: "general/store_information/street_line1",
    value: node[:custom_demo][:configuration][:store_information][:street_line1][:value],
    scope: node[:custom_demo][:configuration][:store_information][:street_line1][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:street_line1][:scope_code]
},
{
    path: "general/store_information/street_line2",
    value: node[:custom_demo][:configuration][:store_information][:street_line2][:value],
    scope: node[:custom_demo][:configuration][:store_information][:street_line2][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:street_line2][:scope_code]
},
{
    path: "general/store_information/city",
    value: node[:custom_demo][:configuration][:store_information][:city][:value],
    scope: node[:custom_demo][:configuration][:store_information][:city][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:city][:scope_code]
},
{
    path: "general/store_information/region_id",
    value: get_locale(node[:custom_demo][:configuration][:store_information][:region_id][:value]),
    scope: node[:custom_demo][:configuration][:store_information][:region_id][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:region_id][:scope_code]
},
{
    path: "general/store_information/postcode",
    value: node[:custom_demo][:configuration][:store_information][:postcode][:value],
    scope: node[:custom_demo][:configuration][:store_information][:postcode][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:postcode][:scope_code]
},
{
    path: "general/store_information/country_id",
    value: get_locale(node[:custom_demo][:configuration][:store_information][:country_id][:value]),
    scope: node[:custom_demo][:configuration][:store_information][:country_id][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:country_id][:scope_code]
},
{
    path: "catalog/product_video/youtube_api_key",
    value: "AIzaSyB-WIL0GOj7vNdC8vgx5cdkV7FDl7D9oYs",
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/related_position_limit",
    value: 5,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/related_position_behavior",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/related_rotation_mode",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/crosssell_position_limit",
    value: 6,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/crosssell_position_behavior",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/crosssell_rotation_mode",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/upsell_position_limit",
    value: 5,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/upsell_position_behavior",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/upsell_rotation_mode",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/enable_eav_indexer",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/engine",
    value: "elasticsearch6",
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_server_hostname",
    value: "127.0.0.1",
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_server_port",
    value: node[:infrastructure][:elasticsearch][:port],
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_index_prefix",
    value: "magento2",
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_enable_auth",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_server_timeout",
    value: 15,
    scope: "default",
    scope_code: ""
},
{
    path: "sales/magento_rma/enabled",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "sales/magento_rma/enabled_on_product",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "sales/magento_rma/use_store_address",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "customer/password/required_character_classes_number",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "customer/password/lockout_failures",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "customer/password/minimum_password_length",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "shipping/origin/street_line1",
    value: node[:custom_demo][:configuration][:shipping][:origin][:street_line1][:value],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:street_line1][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:street_line1][:scope_code]
},
{
    path: "shipping/origin/street_line2",
    value: node[:custom_demo][:configuration][:shipping][:origin][:street_line2][:value],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:street_line2][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:street_line2][:scope_code]
},
{
    path: "shipping/origin/city",
    value: node[:custom_demo][:configuration][:shipping][:origin][:city][:value],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:city][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:city][:scope_code]
},
{
    path: "shipping/origin/region_id",
    value: get_locale(node[:custom_demo][:configuration][:shipping][:origin][:region_id][:value]),
    scope: node[:custom_demo][:configuration][:shipping][:origin][:region_id][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:region_id][:scope_code]
},
{
    path: "shipping/origin/postcode",
    value: node[:custom_demo][:configuration][:shipping][:origin][:postcode][:value],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:postcode][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:postcode][:scope_code]
},
{
    path: "shipping/origin/country_id",
    value: get_locale(node[:custom_demo][:configuration][:shipping][:origin][:country_id][:value]),
    scope: node[:custom_demo][:configuration][:shipping][:origin][:country_id][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:country_id][:scope_code]
},
{
    path: "carriers/ups/active",
    value: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:enable],
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/active_rma",
    value: 1,
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/type",
    value: "UPS_XML",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/mode_xml",
    value: 0,
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/username",
    value: "magento",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/password",
    value: "magento200",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/access_license_number",
    value: "ECAB751ABF189ECA",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/shipper_number",
    value: "207W88",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/allowed_methods",
    value: "01,03",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/free_shipping_enable",
    value: 1,
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/free_method",
    value: "03",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/free_shipping_subtotal",
    value: 1000000000,
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/flatrate/active",
    value: node[:custom_demo][:configuration][:shipping][:carriers][:flatrate][:enable],
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:flatrate][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:flatrate][:scope_code]
},
{
    path: "payment/braintree/active",
    value: node[:custom_demo][:configuration][:payment][:braintree][:enable],
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/title",
    value: "Credit Card",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/environment",
    value: "sandbox",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/payment_action",
    value: node[:custom_demo][:configuration][:payment][:braintree][:payment_action],
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/merchant_account_id",
    value: "magento",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/merchant_id",
    value: "zkw2ctrkj75ndvkc",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/public_key",
    value: "n2bt4844t6xrt56x",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/private_key",
    value: "e6c98fd99fe699d4169475fef026d5b9",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/debug",
    value: 0,
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree_cc_vault/active",
    value: 1,
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/cctypes",
    value: node[:custom_demo][:configuration][:payment][:braintree][:cctypes],
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/useccv",
    value: 1,
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "paypal/general/merchant_country",
    value: node[:custom_demo][:configuration][:payment][:paypal][:merchant_country],
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/braintree_paypal/active",
    value: node[:custom_demo][:configuration][:payment][:paypal][:enable],
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/braintree_paypal/title",
    value: "PayPal",
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/braintree_paypal_vault/active",
    value: 1,
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/braintree_paypal/payment_action",
    value: node[:custom_demo][:configuration][:payment][:paypal][:payment_action],
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/checkmo/active",
    value: node[:custom_demo][:configuration][:payment][:checkmo][:enable],
    scope: node[:custom_demo][:configuration][:payment][:checkmo][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:checkmo][:scope_code]
},
{
    path: "payment/companycredit/active",
    value: node[:custom_demo][:configuration][:payment][:companycredit][:enable],
    scope: node[:custom_demo][:configuration][:payment][:companycredit][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:companycredit][:scope_code]
},
{
    path: "admin/security/admin_account_sharing",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/security/session_lifetime",
    value: 900000,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/security/use_case_sensitive_login",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/security/password_is_forced",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/security/max_number_password_reset_requests",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/dashboard/enable_charts",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "btob/website_configuration/company_active",
    value: node[:custom_demo][:configuration][:b2b][:companies][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:companies][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:companies][:scope_code]
},
{
    path: "btob/website_configuration/negotiablequote_active",
    value: node[:custom_demo][:configuration][:b2b][:quotes][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:quotes][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:quotes][:scope_code]
},
{
    path: "btob/website_configuration/quickorder_active",
    value: node[:custom_demo][:configuration][:b2b][:quick_order][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:quick_order][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:quick_order][:scope_code]
},
{
    path: "btob/website_configuration/requisition_list_active",
    value: node[:custom_demo][:configuration][:b2b][:requisition_lists][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:requisition_lists][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:requisition_lists][:scope_code]
},
{
    path: "btob/website_configuration/sharedcatalog_active",
    value: node[:custom_demo][:configuration][:b2b][:shared_catalogs][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:shared_catalogs][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:shared_catalogs][:scope_code]
},
{
    path: "btob/default_b2b_payment_methods/applicable_payment_methods",
    value: 1,
    scope: "website",
    scope_code: "base"
},
{
    path: "btob/default_b2b_payment_methods/available_payment_methods",
    value: node[:custom_demo][:configuration][:b2b][:payment_methods][:data],
    scope: node[:custom_demo][:configuration][:b2b][:payment_methods][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:payment_methods][:scope_code]
}

# Custom module configuration (Autofill)
default[:custom_demo][:custom_modules][:conf_options] = {
    path: "magentoese_autofill/general/enable_autofill",
    value: node[:custom_demo][:configuration][:autofill][:enable]
},
{
    path: "magentoese_autofill/persona_1/enable",
    value: node[:custom_demo][:configuration][:autofill][:enable]
},
{
    path: "magentoese_autofill/persona_1/label",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:label]
},
{
    path: "magentoese_autofill/persona_1/email_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:email]
},
{
    path: "magentoese_autofill/persona_1/password_value",   
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:password]
},
{
    path: "magentoese_autofill/persona_1/firstname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:first_name]
},
{
    path: "magentoese_autofill/persona_1/lastname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:last_name],
},
{
    path: "magentoese_autofill/persona_1/address_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:address]
},
{
    path: "magentoese_autofill/persona_1/city_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:city]
},
{
    path: "magentoese_autofill/persona_1/state_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:state]
},
{
    path: "magentoese_autofill/persona_1/zip_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:zip]
},
{
    path: "magentoese_autofill/persona_1/country_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:country]
},
{
    path: "magentoese_autofill/persona_1/telephone_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:telephone]
},
{
    path: "magentoese_autofill/persona_1/company_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:company]
},
{
    path: "magentoese_autofill/persona_2/enable",
    value: node[:custom_demo][:configuration][:autofill][:enable]
},
{
    path: "magentoese_autofill/persona_2/label",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:label]
},
{
    path: "magentoese_autofill/persona_2/email_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:email]
},
{
    path: "magentoese_autofill/persona_2/password_value",   
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:password]
},
{
    path: "magentoese_autofill/persona_2/firstname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:first_name],
},
{
    path: "magentoese_autofill/persona_2/lastname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:last_name]
},
{
    path: "magentoese_autofill/persona_2/address_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:address]
},
{
    path: "magentoese_autofill/persona_2/city_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:city]
},
{
    path: "magentoese_autofill/persona_2/state_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:state]
},
{
    path: "magentoese_autofill/persona_2/zip_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:zip]
},
{
    path: "magentoese_autofill/persona_2/country_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:country]
},
{
    path: "magentoese_autofill/persona_2/telephone_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:telephone]
},
{
    path: "magentoese_autofill/persona_2/company_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:company]
},
{
    path: "magentoese_autofill/persona_3/enable",
    value: node[:custom_demo][:configuration][:autofill][:enable]
},
{
    path: "magentoese_autofill/persona_3/label",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:label]
},
{
    path: "magentoese_autofill/persona_3/email_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:email]
},
{
    path: "magentoese_autofill/persona_3/password_value",   
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:password],
},
{
    path: "magentoese_autofill/persona_3/firstname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:first_name]
},
{
    path: "magentoese_autofill/persona_3/lastname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:last_name],
},
{
    path: "magentoese_autofill/persona_3/address_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:address],
},
{
    path: "magentoese_autofill/persona_3/city_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:city]
},
{
    path: "magentoese_autofill/persona_3/state_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:state]
},
{
    path: "magentoese_autofill/persona_3/zip_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:zip]
},
{
    path: "magentoese_autofill/persona_3/country_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:country]
},
{
    path: "magentoese_autofill/persona_3/telephone_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:telephone]
},
{
    path: "magentoese_autofill/persona_3/company_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:company]
},
{
    path: "magentoese_autofill/persona_4/enable",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:enable]
},
{
    path: "magentoese_autofill/persona_4/label",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:label]
},
{
    path: "magentoese_autofill/persona_4/email_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:email]
},
{
    path: "magentoese_autofill/persona_4/password_value",   
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:password],
},
{
    path: "magentoese_autofill/persona_4/firstname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:first_name]
},
{
    path: "magentoese_autofill/persona_4/lastname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:last_name],
},
{
    path: "magentoese_autofill/persona_4/address_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:address],
},
{
    path: "magentoese_autofill/persona_4/city_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:city]
},
{
    path: "magentoese_autofill/persona_4/state_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:state]
},
{
    path: "magentoese_autofill/persona_4/zip_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:zip]
},
{
    path: "magentoese_autofill/persona_4/country_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:country]
},
{
    path: "magentoese_autofill/persona_4/telephone_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:telephone]
},
{
    path: "magentoese_autofill/persona_4/company_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_4][:company]
}

# Configuration overrides
default[:custom_demo][:configuraton_overrides] = {
    elasticsuite: {
        path: "catalog/search/engine",
        value: "elasticsuite",
        scope: "default",
        scope_code: ""
    }
}