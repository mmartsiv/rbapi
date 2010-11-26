class GetData
  
  require 'curb'
  require 'md5'
  
  attr_accessor :url, :controller, :action, :params
  
  
  def initialize(*args)
    args = args.first
    self.controller = args[:controller]
    self.action = args[:action]
    self.params = args[:params] || {}
    self.url = APP_CONFIG_URL
  end
  
  
  def header
    gpartner_secret_key = 'A12345'
    sorted_params = self.params.sort
    joined_params = sorted_params.flatten.join
    signature = Digest::MD5.hexdigest("#{joined_params}#{gpartner_secret_key}")
    {"SIGNATURE" => signature, "GPARTNER_ID" => gpartner_secret_key}
  end
  
  
  def get_url
    if 'POST' == APP_CONFIG[self.controller][self.action]['method']
      "#{self.url}/#{self.controller}/#{self.action}"
    else
      "#{self.url}/#{self.controller}/#{self.action}/#{self.params['account_number']}"
    end
  end
  
  
  
  def request
    curl = Curl::Easy.new get_url
    curl.headers = header
    if 'POST' == APP_CONFIG[self.controller][self.action]['method']
      curl.http_post self.params.map{ |k,v| Curl::PostField.content(k, v) }
    else
      curl.http_get
    end
    curl.body_str
  end
  
  
end