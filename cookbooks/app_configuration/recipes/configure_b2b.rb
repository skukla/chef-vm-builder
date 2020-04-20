#
# Cookbook:: app_configuration
# Recipe:: configure_b2b
#
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
web_root = node[:application][:installation][:options][:directory]
app_config_settings = node[:application][:configuration]
app_config_paths = node[:application][:installation][:application_configuration_paths]
configurations = Array.new

# Helper method
def process_value(user_value)
    regions = [
        {code: "AL", value: "Alabama"}, {code: "AK", value: "Alaska"}, {code: "AS", value: "American Samoa"}, {code: "AZ", value: "Arizona"}, {code: "AR", value: "Arkansas"}, {code: "AE", value: "Armed Forces Africa"}, {code: "AA", value: "Armed Forces Americas"}, {code: "AE", value: "Armed Forces Canada"}, {code: "AE", value: "Armed Forces Europe"}, {code: "AE", value: "Armed Forces Middle East"}, {code: "AP", value: "Armed Forces Pacific"}, {code: "CA", value: "California"}, {code: "CO", value: "Colorado"} ,{code: "CT", value: "Connecticut"}, {code: "DE", value: "Delaware"}, {code: "DC", value: "District of Columbia"}, {code: "FM", value: "Federated States Of Micronesia"}, {code: "FL", value: "Florida"}, {code: "GA", value: "Georgia"}, {code: "GU", value: "Guam"}, {code: "HI", value: "Hawaii"}, {code: "ID", value: "Idaho"}, {code: "IL", value: "Illinois"}, {code: "IN", value: "Indiana"}, {code: "IA", value: "Iowa"}, {code: "KS", value: "Kansas"}, {code: "KY", value: "Kentucky"}, {code: "LA", value: "Louisiana"}, {code: "ME", value: "Maine"}, {code: "MH", value: "Marshall Islands"}, {code: "MD", value: "Maryland"}, {code: "MA", value: "Massachusetts"}, {code: "MI", value: "Michigan"}, {code: "MN", value: "Minnesota"} ,{code: "MS", value: "Mississippi"}, {code: "MO", value: "Missouri"}, {code: "MT", value: "Montana"}, {code: "NE", value: "Nebraska"}, {code: "NV", value: "Nevada"}, {code: "NH", value: "New Hampshire"}, {code: "NJ", value: "New Jersey"}, {code: "NM", value: "New Mexico"}, {code: "NY", value: "New York"}, {code: "NC", value: "North Carolina"}, {code: "ND", value: "North Dakota"} ,{code: "MP", value: "Northern Mariana Islands"}, {code: "OH", value: "Ohio"}, {code: "OK", value: "Oklahoma"}, {code: "OR", value: "Oregon"}, {code: "PW", value: "Palau"}, {code: "PA", value: "Pennsylvania"}, {code: "PR", value: "Puerto Rico"}, {code: "RI", value: "Rhode Island"}, {code: "SC", value: "South Carolina"} ,{code: "SD", value: "South Dakota"}, {code: "TN", value: "Tennessee"}, {code: "TX", value: "Texas"}, {code: "UT", value: "Utah"}, {code: "VT", value: "Vermont"}, {code: "VI", value: "Virgin Islands"}, {code: "VA", value: "Virginia"}, {code: "WA", value: "Washington"}, {code: "WV", value: "West Virginia"}, {code: "WI", value: "Wisconsin"}, {code: "WY", value: "Wyoming"}
    ]
    countries = [
        {code: "AF", value: "Afghanistan"}, {code: "AX", value: "Åland Islands"}, {code: "AL", value: "Albania"}, {code: "DZ", value: "Algeria"}, {code: "AS", value: "American Samoa"}, {code: "AD", value: "Andorra"}, {code: "AO", value: "Angola"}, {code: "AI", value: "Anguilla"}, {code: "AQ", value: "Antarctica"}, {code: "AG", value: "Antigua &amp; Barbuda"}, {code: "AR", value: "Argentina"}, {code: "AM", value: "Armenia"}, {code: "AW", value: "Aruba"}, {code: "AU", value: "Australia"}, {code: "AT", value: "Austria"}, {code: "AZ", value: "Azerbaijan"}, {code: "BS", value: "Bahamas"}, {code: "BH", value: "Bahrain"}, {code: "BD", value: "Bangladesh"}, {code: "BB", value: "Barbados"}, {code: "BY", value: "Belarus"}, {code: "BE", value: "Belgium"}, {code: "BZ", value: "Belize"}, {code: "BJ", value: "Benin"}, {code: "BM", value: "Bermuda"}, {code: "BT", value: "Bhutan"}, {code: "BO", value: "Bolivia"}, {code: "BA", value: "Bosnia &amp; Herzegovina"}, {code: "BW", value: "Botswana"}, {code: "BV", value: "Bouvet Island"}, {code: "BR", value: "Brazil"}, {code: "IO", value: "British Indian Ocean Territory"}, {code: "VG", value: "British Virgin Islands"}, {code: "BN", value: "Brunei"}, {code: "BG", value: "Bulgaria"}, {code: "BF", value: "Burkina Faso"}, {code: "BI", value: "Burundi"}, {code: "KH", value: "Cambodia"}, {code: "CM", value: "Cameroon"}, {code: "CA", value: "Canada"}, {code: "CV", value: "Cape Verde"}, {code: "BQ", value: "Caribbean Netherlands"}, {code: "KY", value: "Cayman Islands"}, {code: "CF", value: "Central African Republic"}, {code: "TD", value: "Chad"}, {code: "CL", value: "Chile"}, {code: "CN", value: "China"}, {code: "CX", value: "Christmas Island"}, {code: "CC", value: "Cocos (Keeling) Islands"}, {code: "CO", value: "Colombia"}, {code: "KM", value: "Comoros"}, {code: "CG", value: "Congo - Brazzaville"}, {code: "CD", value: "Congo - Kinshasa"}, {code: "CK", value: "Cook Islands"}, {code: "CR", value: "Costa Rica"}, {code: "CI", value: "Côte d’Ivoire"}, {code: "HR", value: "Croatia"}, {code: "CU", value: "Cuba"}, {code: "CW", value: "Curaçao"}, {code: "CY", value: "Cyprus"}, {code: "CZ", value: "Czechia"}, {code: "DK", value: "Denmark"}, {code: "DJ", value: "Djibouti"}, {code: "DM", value: "Dominica"}, {code: "DO", value: "Dominican Republic"}, {code: "EC", value: "Ecuador"}, {code: "EG", value: "Egypt"}, {code: "SV", value: "El Salvador"}, {code: "GQ", value: "Equatorial Guinea"}, {code: "ER", value: "Eritrea"}, {code: "EE", value: "Estonia"}, {code: "SZ", value: "Eswatini"}, {code: "ET", value: "Ethiopia"}, {code: "FK", value: "Falkland Islands"}, {code: "FO", value: "Faroe Islands"}, {code: "FJ", value: "Fiji"}, {code: "FI", value: "Finland"}, {code: "FR", value: "France"}, {code: "GF", value: "French Guiana"}, {code: "PF", value: "French Polynesia"}, {code: "TF", value: "French Southern Territories"}, {code: "GA", value: "Gabon"}, {code: "GM", value: "Gambia"}, {code: "GE", value: "Georgia"}, {code: "DE", value: "Germany"}, {code: "GH", value: "Ghana"}, {code: "GI", value: "Gibraltar"}, {code: "GR", value: "Greece"}, {code: "GL", value: "Greenland"}, {code: "GD", value: "Grenada"}, {code: "GP", value: "Guadeloupe"}, {code: "GU", value: "Guam"}, {code: "GT", value: "Guatemala"}, {code: "GG", value: "Guernsey"}, {code: "GN", value: "Guinea"}, {code: "GW", value: "Guinea-Bissau"}, {code: "GY", value: "Guyana"}, {code: "HT", value: "Haiti"}, {code: "HM", value: "Heard &amp; McDonald Islands"}, {code: "HN", value: "Honduras"}, {code: "HK", value: "Hong Kong SAR China"}, {code: "HU", value: "Hungary"}, {code: "IS", value: "Iceland"}, {code: "IN", value: "India"}, {code: "ID", value: "Indonesia"}, {code: "IR", value: "Iran"}, {code: "IQ", value: "Iraq"}, {code: "IE", value: "Ireland"}, {code: "IM", value: "Isle of Man"}, {code: "IL", value: "Israel"}, {code: "IT", value: "Italy"}, {code: "JM", value: "Jamaica"}, {code: "JP", value: "Japan"}, {code: "JE", value: "Jersey"}, {code: "JO", value: "Jordan"}, {code: "KZ", value: "Kazakhstan"}, {code: "KE", value: "Kenya"}, {code: "KI", value: "Kiribati"}, {code: "XK", value: "Kosovo"}, {code: "KW", value: "Kuwait"}, {code: "KG", value: "Kyrgyzstan"}, {code: "LA", value: "Laos"}, {code: "LV", value: "Latvia"}, {code: "LB", value: "Lebanon"}, {code: "LS", value: "Lesotho"}, {code: "LR", value: "Liberia"}, {code: "LY", value: "Libya"}, {code: "LI", value: "Liechtenstein"}, {code: "LT", value: "Lithuania"}, {code: "LU", value: "Luxembourg"}, {code: "MO", value: "Macao SAR China"}, {code: "MG", value: "Madagascar"}, {code: "MW", value: "Malawi"}, {code: "MY", value: "Malaysia"}, {code: "MV", value: "Maldives"}, {code: "ML", value: "Mali"}, {code: "MT", value: "Malta"}, {code: "MH", value: "Marshall Islands"}, {code: "MQ", value: "Martinique"}, {code: "MR", value: "Mauritania"}, {code: "MU", value: "Mauritius"}, {code: "YT", value: "Mayotte"}, {code: "MX", value: "Mexico"}, {code: "FM", value: "Micronesia"}, {code: "MD", value: "Moldova"}, {code: "MC", value: "Monaco"}, {code: "MN", value: "Mongolia"}, {code: "ME", value: "Montenegro"}, {code: "MS", value: "Montserrat"}, {code: "MA", value: "Morocco"}, {code: "MZ", value: "Mozambique"}, {code: "MM", value: "Myanmar (Burma)"}, {code: "NA", value: "Namibia"}, {code: "NR", value: "Nauru"}, {code: "NP", value: "Nepal"}, {code: "NL", value: "Netherlands"}, {code: "NC", value: "New Caledonia"}, {code: "NZ", value: "New Zealand"}, {code: "NI", value: "Nicaragua"}, {code: "NE", value: "Niger"}, {code: "NG", value: "Nigeria"}, {code: "NU", value: "Niue"}, {code: "NF", value: "Norfolk Island"}, {code: "MP", value: "Northern Mariana Islands"}, {code: "KP", value: "North Korea"}, {code: "MK", value: "North Macedonia"}, {code: "NO", value: "Norway"}, {code: "OM", value: "Oman"}, {code: "PK", value: "Pakistan"}, {code: "PW", value: "Palau"}, {code: "PS", value: "Palestinian Territories"}, {code: "PA", value: "Panama"}, {code: "PG", value: "Papua New Guinea"}, {code: "PY", value: "Paraguay"}, {code: "PE", value: "Peru"}, {code: "PH", value: "Philippines"}, {code: "PN", value: "Pitcairn Islands"}, {code: "PL", value: "Poland"}, {code: "PT", value: "Portugal"}, {code: "QA", value: "Qatar"}, {code: "RE", value: "Réunion"}, {code: "RO", value: "Romania"}, {code: "RU", value: "Russia"}, {code: "RW", value: "Rwanda"}, {code: "WS", value: "Samoa"}, {code: "SM", value: "San Marino"}, {code: "ST", value: "São Tomé &amp; Príncipe"}, {code: "SA", value: "Saudi Arabia"}, {code: "SN", value: "Senegal"}, {code: "RS", value: "Serbia"}, {code: "SC", value: "Seychelles"}, {code: "SL", value: "Sierra Leone"}, {code: "SG", value: "Singapore"}, {code: "SX", value: "Sint Maarten"}, {code: "SK", value: "Slovakia"}, {code: "SI", value: "Slovenia"}, {code: "SB", value: "Solomon Islands"}, {code: "SO", value: "Somalia"}, {code: "ZA", value: "South Africa"}, {code: "GS", value: "South Georgia &amp; South Sandwich Islands"}, {code: "KR", value: "South Korea"}, {code: "ES", value: "Spain"}, {code: "LK", value: "Sri Lanka"}, {code: "BL", value: "St. Barthélemy"}, {code: "SH", value: "St. Helena"}, {code: "KN", value: "St. Kitts &amp; Nevis"}, {code: "LC", value: "St. Lucia"}, {code: "MF", value: "St. Martin"}, {code: "PM", value: "St. Pierre &amp; Miquelon"}, {code: "VC", value: "St. Vincent &amp; Grenadines"}, {code: "SD", value: "Sudan"}, {code: "SR", value: "Suriname"}, {code: "SJ", value: "Svalbard &amp; Jan Mayen"}, {code: "SE", value: "Sweden"}, {code: "CH", value: "Switzerland"}, {code: "SY", value: "Syria"}, {code: "TW", value: "Taiwan, Province of China"}, {code: "TJ", value: "Tajikistan"}, {code: "TZ", value: "Tanzania"}, {code: "TH", value: "Thailand"}, {code: "TL", value: "Timor-Leste"}, {code: "TG", value: "Togo"}, {code: "TK", value: "Tokelau"}, {code: "TO", value: "Tonga"}, {code: "TT", value: "Trinidad &amp; Tobago"}, {code: "TN", value: "Tunisia"}, {code: "TR", value: "Turkey"}, {code: "TM", value: "Turkmenistan"}, {code: "TC", value: "Turks &amp; Caicos Islands"}, {code: "TV", value: "Tuvalu"}, {code: "UG", value: "Uganda"}, {code: "UA", value: "Ukraine"}, {code: "AE", value: "United Arab Emirates"}, {code: "GB", value: "United Kingdom"}, {code: "US", value: "United States"}, {code: "UY", value: "Uruguay"}, {code: "UM", value: "U.S. Outlying Islands"}, {code: "VI", value: "U.S. Virgin Islands"}, {code: "UZ", value: "Uzbekistan"}, {code: "VU", value: "Vanuatu"}, {code: "VA", value: "Vatican City"}, {code: "VE", value: "Venezuela"}, {code: "VN", value: "Vietnam"}, {code: "WF", value: "Wallis &amp; Futuna"}, {code: "EH", value: "Western Sahara"}, {code: "YE", value: "Yemen"}, {code: "ZM", value: "Zambia"}, {code: "ZW", value: "Zimbabwe"}
    ]
    shipping_methods = [
        {code: "11", value: "UPS Standard"},
        {code: "12", value: "UPS Three-Day Select"},
        {code: "14", value: "UPS Next Day Air Early A.M."}, 
        {code: "54", value: "UPS Worldwide Express Plus"}, 
        {code: "59", value: "UPS Second Day Air A.M."}, 
        {code: "65", value: "UPS Worldwide Saver"}, 
        {code: "01", value: "UPS Next Day Air"}, 
        {code: "02", value: "UPS Second Day Air"}, 
        {code: "03", value: "UPS Ground"}, 
        {code: "07", value: "UPS Worldwide Express"}, 
        {code: "08", value: "UPS Worldwide Expedited"}
    ]
    payment_methods = [
        {code: "CUP", value: "China Union Pay"}, 
        {code: "AE", value: "American Express"},     
        {code: "VI", value: "Visa"},
        {code: "MC", value: "MasterCard"}, 
        {code: "DI", value: "Discover"}, 
        {code: "DC", value: "Diner's"}, 
        {code: "JCB", value: "Japan Credit Bureau"}, 
        {code: "MI", value: "Maestro International"}
    ]
    website_restriction_modes = [
        {code: "0", value: "Website Closed"}, 
        {code: "1", value: "Login and Register"}, 
        {code: "2", value: "Login Only"}
    ]
    website_restriction_startup_pages = [
        {code: "0", value: "Login form"}, 
        {code: "1", value: "Landing page"}
    ]
    website_restriction_landing_pages = [
        {code: "no-route", value: "404 Not Found"}, 
        {code: "home", value: "Home page"}, 
        {code: "enable-cookies", value: "Enable Cookies"},
        {code: "privacy-policy-cookie-restriction-mode", value: "Privacy and Cookie Policy"},
        {code: "access-denied-page", value: "Company: Access Denied"},
        {code: "service-unavailable", value: "503 Service Unavailable"},
        {code: "private-sales", value: "Welcome to our Exclusive Online Store"},
        {code: "reward-points", value: "Reward Points"}
    ]
    [
        regions,
        payment_methods, 
        shipping_methods,
        countries,
        website_restriction_modes,
        website_restriction_startup_pages,
        website_restriction_landing_pages
    ].each do |setting_group|
        case setting_group
        when regions
            setting_group.each_with_index do |setting_data, setting_index|
                if setting_data[:value] == user_value || user_value == setting_data[:code]    
                    return setting_index + 1
                end
            end
        when payment_methods, shipping_methods
            if user_value.is_a? Array
                results = Array.new
                user_value.each{|v| results << setting_group.select{|method_data| method_data[:value].downcase.include?(v.downcase) or method_data[:code].downcase == v.downcase }.map{|method_data| method_data[:code]}}
                unless results.flatten.empty?
                    return results.join(",")
                end
            end
        when countries, website_restriction_modes, website_restriction_startup_pages, website_restriction_landing_pages
            setting_group.each do |setting_data|
                if setting_data[:value] == user_value || user_value == setting_data[:code]
                    return setting_data[:code]
                end
            end
        end
    end
    # Booleans
    if user_value == true
        return 1
    elsif user_value == false
        return 0
    else
        return user_value
    end
end

if node[:application].has_key?(:configuration)
    app_config_paths.each do |config_path|
        unless config_path.include?("btob")
            next
        else
            configured_setting = app_config_settings.dig(*config_path.split("/"))
            if configured_setting.class != NilClass and configured_setting.class != Chef::Node::ImmutableMash
                # User-configured settings with default scope
                configuration_setting = {
                    path: config_path,
                    value: configured_setting
                }
                configurations << configuration_setting
            elsif configured_setting.class != NilClass or configured_setting.class == Chef::Node::ImmutableMash
                [:website, :store].each do |scope|
                    if configured_setting[:scopes].has_key?(scope)
                        # Website or store-view settings
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
    unless configurations.empty?
        command_string = "#{web_root}/bin/magento config:set "
        configurations.each do |setting|
            if setting.has_key?(:scope)
                scope_string = "--scope=#{setting[:scope]} --scope-code=#{setting[:code]} "
            end
            config_string = "#{setting[:path]} \"#{process_value(setting[:value])}\""
            execute "Configuring b2b setting : #{setting[:path]}" do
                command [command_string, scope_string, config_string].join
            end
        end
    end
end