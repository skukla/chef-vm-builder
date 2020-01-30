name "vm"
description "Configuration file for the Kukla Demo VM"
default_attributes(
	custom_demo: {
        verticals: {
            fashion: true,
            automotive: false,
            fsi: false,
            custom: true
        },
        channels: {
            b2b: true,
            b2c: true
        },
        geos: [
            'us_en'
        ]
    },
    application: {
        authentication: {
            composer: {
                username: 'b17aa908c13768cef2a5a3a043bb3c54',
                password: '93f1f71fd779eb46af01fd7587e5fdba'
            },
            github: {
                oauth_token: ''
            }
        },
        settings: {
            family: 'Commerce',
            version: '*',
            download: true,
            sample_data: false,
            install: true
        }
    },
    vm: {
        ip: '192.168.57.11'
    },
    infrastructure: {
        php: {
            version: '7.3',
            port: 9000
        },
        webserver: {
            port: 80
        },
        database: {
            user: 'magento',
            password: 'password',
            name: 'magento'
        },
        elasticsearch: {
			use: true,
			version: '6.8.5',
            port: 9200
        },
		mailhog: {
			use: true,
			port: 10000
		},
        webmin: {
            use: true,
            port: 20000
        },
        samba: {
            use: true,
            shares: {
                composer_credentials: true,
                image_drop: true,
                web_root: true,
                app_modules: true,
                multisite_configuration: true,
                app_design: true
            }
        }
    }
)
