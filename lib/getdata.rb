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
    gpartner_id = '2747'
    gpartner_secret_key = 'RB-1251951457r31E20E3B84B4F1C7E0'
    parameters = {
       'first_name' => self.params[:first_name].nil? ? "" : self.params[:first_name],
       'last_name' => self.params[:last_name].nil? ? "" : self.params[:last_name],
       'account_number' => self.params[:account_number].nil? ? "" : self.params[:account_number],
       'email' => self.params[:email].nil? ? "" : self.params[:email]
     }
    #sorted_params = parameters.sort
    sorted_params = parameters.sort_by {|key,value| key}
    joined_params = sorted_params.flatten.join
    str_tohash = "#{joined_params}#{gpartner_secret_key}"
    signature = Digest::MD5.hexdigest("#{joined_params}#{gpartner_secret_key}")
    {"SIGNATURE" => signature, "GPARTNER_ID" => gpartner_id}
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