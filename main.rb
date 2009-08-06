#!/usr/bin/ruby
#post tumblr quote
#tumblr api reference: http://www.tumblr.com/api#authenticated_read
require 'net/http'
require 'kconv'
require 'parse_text.rb'

HOST = 'www.tumblr.com'
PATH = '/api/write'
AUTH_EMAIL = 'gohannnotomo@gmail.com'
AUTH_PASS  = 'kokihashimoto'
HTTP_POST_SUCCESS = '201'

def create_post(data)
# email - Your account's email address.
# password - Your account's password.
# type - The post type.
# (content parameters)- These vary by post type.
  quote   = data[:quote]
  source  = data[:title] + " - " + data[:source]
  tags    = data[:title]

  data = {
  'email'    => AUTH_EMAIL,
  'password' => AUTH_PASS,
  'type'     => 'quote',
  'quote'    => quote,
  'source'   => source,
  'tags'   => tags
  }
  post_data = ''
  data.each {|k,v|
    post_data += '&' unless post_data == ''
    post_data +="#{k}=#{v}"
  }
  return post_data.toutf8 #toutf8しないと文字化けする
end

docs = Parser.new("quote.txt").docs
Net::HTTP.start(HOST){ |http|
  docs.each {|d|
    post_data = create_post(d)
    response = http.post(PATH, post_data)
    unless response.code == HTTP_POST_SUCCESS
      puts 'Error occured. Check your dashbord.',
        "code#{response.code}"
        "message#{response.message}"
    end
  }
}


