OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, '426565478156-ltseioh3b35j4qs83a16vblrmmldd9ht.apps.googleusercontent.com', 'AILaYya6VGGW2BY0MNaUoETw', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
