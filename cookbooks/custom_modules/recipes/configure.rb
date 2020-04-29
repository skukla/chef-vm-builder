#
# Cookbook:: custom_modules
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
apply_custom_flag = node[:application][:installation][:options][:configuration][:custom_modules]
custom_module_data = node[:custom_demo][:custom_modules]
configurations = Array.new

# Helper method
def process_value(value)
    regions = [{postal_code: "AL", value: "Alabama"}, {postal_code: "AK", value: "Alaska"}, {postal_code: "AS", value: "American Samoa"}, {postal_code: "AZ", value: "Arizona"}, {postal_code: "AR", value: "Arkansas"}, {postal_code: "AE", value: "Armed Forces Africa"}, {postal_code: "AA", value: "Armed Forces Americas"}, {postal_code: "AE", value: "Armed Forces Canada"}, {postal_code: "AE", value: "Armed Forces Europe"}, {postal_code: "AE", value: "Armed Forces Middle East"}, {postal_code: "AP", value: "Armed Forces Pacific"}, {postal_code: "CA", value: "California"}, {postal_code: "CO", value: "Colorado"} ,{postal_code: "CT", value: "Connecticut"}, {postal_code: "DE", value: "Delaware"}, {postal_code: "DC", value: "District of Columbia"}, {postal_code: "FM", value: "Federated States Of Micronesia"}, {postal_code: "FL", value: "Florida"}, {postal_code: "GA", value: "Georgia"}, {postal_code: "GU", value: "Guam"}, {postal_code: "HI", value: "Hawaii"}, {postal_code: "ID", value: "Idaho"}, {postal_code: "IL", value: "Illinois"}, {postal_code: "IN", value: "Indiana"}, {postal_code: "IA", value: "Iowa"}, {postal_code: "KS", value: "Kansas"}, {postal_code: "KY", value: "Kentucky"}, {postal_code: "LA", value: "Louisiana"}, {postal_code: "ME", value: "Maine"}, {postal_code: "MH", value: "Marshall Islands"}, {postal_code: "MD", value: "Maryland"}, {postal_code: "MA", value: "Massachusetts"}, {postal_code: "MI", value: "Michigan"}, {postal_code: "MN", value: "Minnesota"} ,{postal_code: "MS", value: "Mississippi"}, {postal_code: "MO", value: "Missouri"}, {postal_code: "MT", value: "Montana"}, {postal_code: "NE", value: "Nebraska"}, {postal_code: "NV", value: "Nevada"}, {postal_code: "NH", value: "New Hampshire"}, {postal_code: "NJ", value: "New Jersey"}, {postal_code: "NM", value: "New Mexico"}, {postal_code: "NY", value: "New York"}, {postal_code: "NC", value: "North Carolina"}, {postal_code: "ND", value: "North Dakota"} ,{postal_code: "MP", value: "Northern Mariana Islands"}, {postal_code: "OH", value: "Ohio"}, {postal_code: "OK", value: "Oklahoma"}, {postal_code: "OR", value: "Oregon"}, {postal_code: "PW", value: "Palau"}, {postal_code: "PA", value: "Pennsylvania"}, {postal_code: "PR", value: "Puerto Rico"}, {postal_code: "RI", value: "Rhode Island"}, {postal_code: "SC", value: "South Carolina"} ,{postal_code: "SD", value: "South Dakota"}, {postal_code: "TN", value: "Tennessee"}, {postal_code: "TX", value: "Texas"}, {postal_code: "UT", value: "Utah"}, {postal_code: "VT", value: "Vermont"}, {postal_code: "VI", value: "Virgin Islands"}, {postal_code: "VA", value: "Virginia"}, {postal_code: "WA", value: "Washington"}, {postal_code: "WV", value: "West Virginia"}, {postal_code: "WI", value: "Wisconsin"}, {postal_code: "WY", value: "Wyoming"}]

    countries = [{postal_code: "AF", value: "Afghanistan"}, {postal_code: "AX", value: "Åland Islands"}, {postal_code: "AL", value: "Albania"}, {postal_code: "DZ", value: "Algeria"}, {postal_code: "AS", value: "American Samoa"}, {postal_code: "AD", value: "Andorra"}, {postal_code: "AO", value: "Angola"}, {postal_code: "AI", value: "Anguilla"}, {postal_code: "AQ", value: "Antarctica"}, {postal_code: "AG", value: "Antigua &amp; Barbuda"}, {postal_code: "AR", value: "Argentina"}, {postal_code: "AM", value: "Armenia"}, {postal_code: "AW", value: "Aruba"}, {postal_code: "AU", value: "Australia"}, {postal_code: "AT", value: "Austria"}, {postal_code: "AZ", value: "Azerbaijan"}, {postal_code: "BS", value: "Bahamas"}, {postal_code: "BH", value: "Bahrain"}, {postal_code: "BD", value: "Bangladesh"}, {postal_code: "BB", value: "Barbados"}, {postal_code: "BY", value: "Belarus"}, {postal_code: "BE", value: "Belgium"}, {postal_code: "BZ", value: "Belize"}, {postal_code: "BJ", value: "Benin"}, {postal_code: "BM", value: "Bermuda"}, {postal_code: "BT", value: "Bhutan"}, {postal_code: "BO", value: "Bolivia"}, {postal_code: "BA", value: "Bosnia &amp; Herzegovina"}, {postal_code: "BW", value: "Botswana"}, {postal_code: "BV", value: "Bouvet Island"}, {postal_code: "BR", value: "Brazil"}, {postal_code: "IO", value: "British Indian Ocean Territory"}, {postal_code: "VG", value: "British Virgin Islands"}, {postal_code: "BN", value: "Brunei"}, {postal_code: "BG", value: "Bulgaria"}, {postal_code: "BF", value: "Burkina Faso"}, {postal_code: "BI", value: "Burundi"}, {postal_code: "KH", value: "Cambodia"}, {postal_code: "CM", value: "Cameroon"}, {postal_code: "CA", value: "Canada"}, {postal_code: "CV", value: "Cape Verde"}, {postal_code: "BQ", value: "Caribbean Netherlands"}, {postal_code: "KY", value: "Cayman Islands"}, {postal_code: "CF", value: "Central African Republic"}, {postal_code: "TD", value: "Chad"}, {postal_code: "CL", value: "Chile"}, {postal_code: "CN", value: "China"}, {postal_code: "CX", value: "Christmas Island"}, {postal_code: "CC", value: "Cocos (Keeling) Islands"}, {postal_code: "CO", value: "Colombia"}, {postal_code: "KM", value: "Comoros"}, {postal_code: "CG", value: "Congo - Brazzaville"}, {postal_code: "CD", value: "Congo - Kinshasa"}, {postal_code: "CK", value: "Cook Islands"}, {postal_code: "CR", value: "Costa Rica"}, {postal_code: "CI", value: "Côte d’Ivoire"}, {postal_code: "HR", value: "Croatia"}, {postal_code: "CU", value: "Cuba"}, {postal_code: "CW", value: "Curaçao"}, {postal_code: "CY", value: "Cyprus"}, {postal_code: "CZ", value: "Czechia"}, {postal_code: "DK", value: "Denmark"}, {postal_code: "DJ", value: "Djibouti"}, {postal_code: "DM", value: "Dominica"}, {postal_code: "DO", value: "Dominican Republic"}, {postal_code: "EC", value: "Ecuador"}, {postal_code: "EG", value: "Egypt"}, {postal_code: "SV", value: "El Salvador"}, {postal_code: "GQ", value: "Equatorial Guinea"}, {postal_code: "ER", value: "Eritrea"}, {postal_code: "EE", value: "Estonia"}, {postal_code: "SZ", value: "Eswatini"}, {postal_code: "ET", value: "Ethiopia"}, {postal_code: "FK", value: "Falkland Islands"}, {postal_code: "FO", value: "Faroe Islands"}, {postal_code: "FJ", value: "Fiji"}, {postal_code: "FI", value: "Finland"}, {postal_code: "FR", value: "France"}, {postal_code: "GF", value: "French Guiana"}, {postal_code: "PF", value: "French Polynesia"}, {postal_code: "TF", value: "French Southern Territories"}, {postal_code: "GA", value: "Gabon"}, {postal_code: "GM", value: "Gambia"}, {postal_code: "GE", value: "Georgia"}, {postal_code: "DE", value: "Germany"}, {postal_code: "GH", value: "Ghana"}, {postal_code: "GI", value: "Gibraltar"}, {postal_code: "GR", value: "Greece"}, {postal_code: "GL", value: "Greenland"}, {postal_code: "GD", value: "Grenada"}, {postal_code: "GP", value: "Guadeloupe"}, {postal_code: "GU", value: "Guam"}, {postal_code: "GT", value: "Guatemala"}, {postal_code: "GG", value: "Guernsey"}, {postal_code: "GN", value: "Guinea"}, {postal_code: "GW", value: "Guinea-Bissau"}, {postal_code: "GY", value: "Guyana"}, {postal_code: "HT", value: "Haiti"}, {postal_code: "HM", value: "Heard &amp; McDonald Islands"}, {postal_code: "HN", value: "Honduras"}, {postal_code: "HK", value: "Hong Kong SAR China"}, {postal_code: "HU", value: "Hungary"}, {postal_code: "IS", value: "Iceland"}, {postal_code: "IN", value: "India"}, {postal_code: "ID", value: "Indonesia"}, {postal_code: "IR", value: "Iran"}, {postal_code: "IQ", value: "Iraq"}, {postal_code: "IE", value: "Ireland"}, {postal_code: "IM", value: "Isle of Man"}, {postal_code: "IL", value: "Israel"}, {postal_code: "IT", value: "Italy"}, {postal_code: "JM", value: "Jamaica"}, {postal_code: "JP", value: "Japan"}, {postal_code: "JE", value: "Jersey"}, {postal_code: "JO", value: "Jordan"}, {postal_code: "KZ", value: "Kazakhstan"}, {postal_code: "KE", value: "Kenya"}, {postal_code: "KI", value: "Kiribati"}, {postal_code: "XK", value: "Kosovo"}, {postal_code: "KW", value: "Kuwait"}, {postal_code: "KG", value: "Kyrgyzstan"}, {postal_code: "LA", value: "Laos"}, {postal_code: "LV", value: "Latvia"}, {postal_code: "LB", value: "Lebanon"}, {postal_code: "LS", value: "Lesotho"}, {postal_code: "LR", value: "Liberia"}, {postal_code: "LY", value: "Libya"}, {postal_code: "LI", value: "Liechtenstein"}, {postal_code: "LT", value: "Lithuania"}, {postal_code: "LU", value: "Luxembourg"}, {postal_code: "MO", value: "Macao SAR China"}, {postal_code: "MG", value: "Madagascar"}, {postal_code: "MW", value: "Malawi"}, {postal_code: "MY", value: "Malaysia"}, {postal_code: "MV", value: "Maldives"}, {postal_code: "ML", value: "Mali"}, {postal_code: "MT", value: "Malta"}, {postal_code: "MH", value: "Marshall Islands"}, {postal_code: "MQ", value: "Martinique"}, {postal_code: "MR", value: "Mauritania"}, {postal_code: "MU", value: "Mauritius"}, {postal_code: "YT", value: "Mayotte"}, {postal_code: "MX", value: "Mexico"}, {postal_code: "FM", value: "Micronesia"}, {postal_code: "MD", value: "Moldova"}, {postal_code: "MC", value: "Monaco"}, {postal_code: "MN", value: "Mongolia"}, {postal_code: "ME", value: "Montenegro"}, {postal_code: "MS", value: "Montserrat"}, {postal_code: "MA", value: "Morocco"}, {postal_code: "MZ", value: "Mozambique"}, {postal_code: "MM", value: "Myanmar (Burma)"}, {postal_code: "NA", value: "Namibia"}, {postal_code: "NR", value: "Nauru"}, {postal_code: "NP", value: "Nepal"}, {postal_code: "NL", value: "Netherlands"}, {postal_code: "NC", value: "New Caledonia"}, {postal_code: "NZ", value: "New Zealand"}, {postal_code: "NI", value: "Nicaragua"}, {postal_code: "NE", value: "Niger"}, {postal_code: "NG", value: "Nigeria"}, {postal_code: "NU", value: "Niue"}, {postal_code: "NF", value: "Norfolk Island"}, {postal_code: "MP", value: "Northern Mariana Islands"}, {postal_code: "KP", value: "North Korea"}, {postal_code: "MK", value: "North Macedonia"}, {postal_code: "NO", value: "Norway"}, {postal_code: "OM", value: "Oman"}, {postal_code: "PK", value: "Pakistan"}, {postal_code: "PW", value: "Palau"}, {postal_code: "PS", value: "Palestinian Territories"}, {postal_code: "PA", value: "Panama"}, {postal_code: "PG", value: "Papua New Guinea"}, {postal_code: "PY", value: "Paraguay"}, {postal_code: "PE", value: "Peru"}, {postal_code: "PH", value: "Philippines"}, {postal_code: "PN", value: "Pitcairn Islands"}, {postal_code: "PL", value: "Poland"}, {postal_code: "PT", value: "Portugal"}, {postal_code: "QA", value: "Qatar"}, {postal_code: "RE", value: "Réunion"}, {postal_code: "RO", value: "Romania"}, {postal_code: "RU", value: "Russia"}, {postal_code: "RW", value: "Rwanda"}, {postal_code: "WS", value: "Samoa"}, {postal_code: "SM", value: "San Marino"}, {postal_code: "ST", value: "São Tomé &amp; Príncipe"}, {postal_code: "SA", value: "Saudi Arabia"}, {postal_code: "SN", value: "Senegal"}, {postal_code: "RS", value: "Serbia"}, {postal_code: "SC", value: "Seychelles"}, {postal_code: "SL", value: "Sierra Leone"}, {postal_code: "SG", value: "Singapore"}, {postal_code: "SX", value: "Sint Maarten"}, {postal_code: "SK", value: "Slovakia"}, {postal_code: "SI", value: "Slovenia"}, {postal_code: "SB", value: "Solomon Islands"}, {postal_code: "SO", value: "Somalia"}, {postal_code: "ZA", value: "South Africa"}, {postal_code: "GS", value: "South Georgia &amp; South Sandwich Islands"}, {postal_code: "KR", value: "South Korea"}, {postal_code: "ES", value: "Spain"}, {postal_code: "LK", value: "Sri Lanka"}, {postal_code: "BL", value: "St. Barthélemy"}, {postal_code: "SH", value: "St. Helena"}, {postal_code: "KN", value: "St. Kitts &amp; Nevis"}, {postal_code: "LC", value: "St. Lucia"}, {postal_code: "MF", value: "St. Martin"}, {postal_code: "PM", value: "St. Pierre &amp; Miquelon"}, {postal_code: "VC", value: "St. Vincent &amp; Grenadines"}, {postal_code: "SD", value: "Sudan"}, {postal_code: "SR", value: "Suriname"}, {postal_code: "SJ", value: "Svalbard &amp; Jan Mayen"}, {postal_code: "SE", value: "Sweden"}, {postal_code: "CH", value: "Switzerland"}, {postal_code: "SY", value: "Syria"}, {postal_code: "TW", value: "Taiwan, Province of China"}, {postal_code: "TJ", value: "Tajikistan"}, {postal_code: "TZ", value: "Tanzania"}, {postal_code: "TH", value: "Thailand"}, {postal_code: "TL", value: "Timor-Leste"}, {postal_code: "TG", value: "Togo"}, {postal_code: "TK", value: "Tokelau"}, {postal_code: "TO", value: "Tonga"}, {postal_code: "TT", value: "Trinidad &amp; Tobago"}, {postal_code: "TN", value: "Tunisia"}, {postal_code: "TR", value: "Turkey"}, {postal_code: "TM", value: "Turkmenistan"}, {postal_code: "TC", value: "Turks &amp; Caicos Islands"}, {postal_code: "TV", value: "Tuvalu"}, {postal_code: "UG", value: "Uganda"}, {postal_code: "UA", value: "Ukraine"}, {postal_code: "AE", value: "United Arab Emirates"}, {postal_code: "GB", value: "United Kingdom"}, {postal_code: "US", value: "United States"}, {postal_code: "UY", value: "Uruguay"}, {postal_code: "UM", value: "U.S. Outlying Islands"}, {postal_code: "VI", value: "U.S. Virgin Islands"}, {postal_code: "UZ", value: "Uzbekistan"}, {postal_code: "VU", value: "Vanuatu"}, {postal_code: "VA", value: "Vatican City"}, {postal_code: "VE", value: "Venezuela"}, {postal_code: "VN", value: "Vietnam"}, {postal_code: "WF", value: "Wallis &amp; Futuna"}, {postal_code: "EH", value: "Western Sahara"}, {postal_code: "YE", value: "Yemen"}, {postal_code: "ZM", value: "Zambia"}, {postal_code: "ZW", value: "Zimbabwe"}]

    payment_methods = [{code: "CUP", value: "China Union Pay"}, {code: "AE", value: "American Express"}, {code: "VI", value: "Visa"}, {code: "MC", value: "Mastercard"}, {code: "DI", value: "Discover"}, {code: "DC", value: "Diner's"}, {code: "JCB", value: "Japan Credit Bureau"}, {code: "MI", value: "Maestro International"}]
    
    shipping_methods = [{code: "11", value: "UPS Standard"}, {code: "12", value: "UPS Three-Day Select"}, {code: "14", value: "UPS Next Day Air Early A.M."}, {code: "54", value: "UPS Worldwide Express Plus"}, {code: "59", value: "UPS Second Day Air A.M."}, {code: "65", value: "UPS Worldwide Saver"}, {code: "01", value: "UPS Next Day Air"}, {code: "02", value: "UPS Second Day Air"}, {code: "03", value: "UPS Ground"}, {code: "07", value: "UPS Worldwide Express"}, {code: "08", value: "UPS Worldwide Expedited"}]
    
    # Regions
    regions.each_with_index do |region, index|
        if value == region[:value] || value == region[:postal_code]
            return index + 1
        end
    end
    
    # Countries
    countries.each do |country, index|
        if value == country[:value] || value == country[:postal_code]
            return country[:postal_code]
        end
    end
    
    # Payment Methods
    if value.is_a? Array
        payment_methods.each do |payment_method|
            value.each do |cc_value|
                if payment_method[:value].include?(cc_value) || cc_value == payment_method[:code]
                    cc_types_array << payment_method[:code]
                end
            end
        end
        unless cc_types_array.empty? 
            return cc_types_array.join(",")
        end
        

        # Shipping Methods
        shipping_methods.each do |shipping_method|
            value.each do |shipping_value|
                if shipping_method[:value].include?(shipping_value) || shipping_value == shipping_method[:code]
                    shipping_methods_array << shipping_method[:code]
                end
            end
        end
        unless shipping_methods_array.empty? 
            return shipping_methods_array.join(",")
        end
    end
    
    # Booleans
    if value == true
        return 1
    elsif value == false
        return 0
    end
    
    return value
end

custom_module_data.each do |module_key, module_value|
    if node[:custom_demo].has_key?(module_key.gsub(/-/,"_"))
        if node[:custom_demo][:custom_modules][module_key].has_key?(:configuration)
            custom_module_settings = node[:custom_demo][:custom_modules][module_key][:configuration]
        end
        custom_module_config_paths = node[:custom_demo][module_key.gsub(/-/,"_")][:config_paths]
        custom_module_config_paths.each do |config_path|
            configured_setting = custom_module_settings.dig(*config_path.split("/"))
            if !apply_custom_flag
                next
            else 
                if configured_setting.class != NilClass and configured_setting.class != Chef::Node::ImmutableMash
                    # Default scope settings
                    configuration_setting = {
                        path: config_path,
                        value: configured_setting
                    }
                    configurations << configuration_setting
                elsif configured_setting.class != NilClass or configured_setting.class == Chef::Node::ImmutableMash
                    [:website, :store].each do |scope|
                        if configured_setting[:scopes].has_key?(scope)
                            # Scoped settings
                            configuration_setting = {
                                path: config_path,
                                value: configured_setting[:scopes][scope][:value],
                                scope: scope,
                                code: configured_setting[:scopes][scope][:code]
                            }
                            configurations << configuration_setting
                        end
                    end
                end
            end
        end
    end
end 

unless configurations.empty?
    command_string = "#{web_root}/bin/magento config:set "
    configurations.each do |setting|
        if setting.has_key?(:scope)
            scope_string = "--scope=#{setting[:scope]} --scope-code=#{setting[:code]} "
        end
        config_string = "#{setting[:path]} \"#{process_value(setting[:value])}\""
        execute "Configuring custom module setting : #{setting[:path]}" do
            command [command_string, scope_string, config_string].join
        end
    end
end