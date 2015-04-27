require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'
require 'fileutils'

APPLICATION_NAME = 'Calendar API Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-api-quickstart.json")
SCOPE = 'https://www.googleapis.com/auth/calendar'

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization request via InstalledAppFlow.
# If authorization is required, the user's default browser will be launched
# to approve the request.
#
# @return [Signet::OAuth2::Client] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
  storage = Google::APIClient::Storage.new(file_store)
  auth = storage.authorize

  if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
    app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
    flow = Google::APIClient::InstalledAppFlow.new({
      :client_id => app_info.client_id,
      :client_secret => app_info.client_secret,
      :scope => SCOPE})
    auth = flow.authorize(storage)
    puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
  end
  auth
end

# Initialize the API
client = Google::APIClient.new(:application_name => APPLICATION_NAME)
calendar_api = client.discovered_api('calendar', 'v3')
client.authorization = authorize

#event = {
#  'summary' => 'Test Appointment',
#  'location' => 'Somewhere',
#  'start' => {
#    'dateTime' => '2015-04-25T10:00:00'
#  },
#  'end' => {
#    'dateTime' => '2015-04-25T10:25:00'
#  },
#}

event = {
 "end": {
  "dateTime": "2015-05-01T10:30:00.000-07:00"
 },
 "start": {
  "dateTime": "2015-05-01T10:00:00.000-07:00"
 }
}


result = client.execute(:api_method => calendar_api.events.insert,
                        :parameters => {'calendarId' => 'primary'},
                        :body => JSON.dump(event),
                        :headers => {'Content-Type' => 'application/json'})
print 'errors: %s' % result.data.error
print result.data.id
