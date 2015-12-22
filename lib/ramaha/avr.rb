class Ramaha::AVR
  attr :host, :port

  DEFAULTS = {
    :host => "192.168.178.51",
    :port => 80,
    :endpoint => "/YamahaRemoteControl/ctrl"
  }

  POWER_ON_CMD = '<YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Power>On</Power></Power_Control></Main_Zone></YAMAHA_AV>'
  POWER_OFF_CMD = '<YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Power>Standby</Power></Power_Control></Main_Zone></YAMAHA_AV>'
  VOLUME_GET = '<YAMAHA_AV cmd="GET"><Main_Zone><Volume><Lvl>GetParam</Lvl></Volume></Main_Zone></YAMAHA_AV>'
  # play info for tuner
  PLAY_INFO = '<YAMAHA_AV cmd="GET"><Tuner><Play_Info>GetParam</Play_Info></Tuner></YAMAHA_AV>'

  def initialize(options = {})
    raise ArgumentError, 'Hash as parameter expected!' unless options.class == Hash
    @options = _parse_options(options)
  end

  def power_on
    RestClient.post(request_url, POWER_ON_CMD, :content_type => "text/xml")
  end

  def power_off
    RestClient.post(request_url, POWER_OFF_CMD, :content_type => "text/xml")
  end

  def volume_up
    RestClient.post(request_url, VOLUME_GET, :content_type => "text/xml")
  end

  def volume_down
    RestClient.post(request_url, VOLUME_GET, :content_type => "text/xml")
  end

  def volume(db)
    RestClient.post(request_url, '<YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>'+db.to_s+'</Val><Exp>1</Exp><Unit>dB</Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>', :content_type => "text/xml")
  end

  # HDMI1, AV4, USB, TUNER, SERVER, ...
  def input(input)
    RestClient.post(request_url, '<YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>'+input+'</Input_Sel></Input></Main_Zone></YAMAHA_AV>', :content_type => "text/xml")
  end

  def rc_cmd(code)
    RestClient.post(request_url, '<YAMAHA_AV cmd="PUT"><Main_Zone><Remote_Control><RC_Code>'+code+'</RC_Code></Remote_Control></Main_Zone></YAMAHA_AV>', :content_type => "text/xml")
  end

  def play_info
    RestClient.post(request_url, PLAY_INFO, :content_type => "text/xml")
    #TODO: pars result
  end



  # def current_channel
  #   doc = Nokogiri::HTML(open(base_url+"/SystemInformation.htm", :http_basic_authentication=>[@options[:user], @options[:password]]))
  #   doc.search('/html/body/table/tbody/tr/td/table/tbody/tr[6]/td[3]/table/tbody/tr[4]/td/b/text()[3]').text
  # end



  protected

    def base_url
      "http://#{@options[:host]}:#{@options[:port]}"
    end

    def request_url
      "#{base_url}#{@options[:endpoint]}"
    end

    def _parse_options(options)
      defaults = DEFAULTS.dup
      options = options.dup

      defaults.keys.each do |key|
        # Fill in defaults if needed
        if defaults[key].respond_to?(:call)
          defaults[key] = defaults[key].call
        end

        # Symbolize only keys that are needed
        options[key] = options[key.to_s] if options.has_key?(key.to_s)
      end

      # Use defaults if not already defined by options
      defaults.keys.each do |key|
        options[key] ||= defaults[key]
      end

      options[:port] = options[:port].to_i

      options
    end
end