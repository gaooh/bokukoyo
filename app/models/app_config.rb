
module AppConfig
   Config = Struct.new(:from_name, :from_url, :ping_url, :storage_path)
   
   def self.define_config
     @config = Config.new
     {:from_name     => "",
      :from_url      => "",
      :ping_url      => "",
      :storage_path  => ""
      }.each do |key| @config.send("#{key.first}=", key.last) end
     yield @config
   end
   
   def self.config; @config;end
   
end