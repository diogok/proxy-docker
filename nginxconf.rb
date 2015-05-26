#!/usr/bin/env ruby

require 'uri'
require 'json'
require 'net/http'
require 'erb'
require 'zlib'

consul = "http://#{ENV["CONSUL_PORT_8500_TCP_ADDR"]}:8500"

def http_get(uri)
    JSON.parse(Net::HTTP.get(URI(uri)))
end

class Namespace
  def initialize(data,config)
    @data=data
    @config=config
  end
  def get_binding
    binding
  end
end

last = ""
template = File.read("/etc/nginx/nginx.conf.erb")

while true do
  sleep 2

  data={}

  http_get("#{consul}/v1/catalog/services").each{|k,v|
    http_get("#{consul}/v1/catalog/service/#{k}").each{|v|
      id = /:([a-zA-Z0-9-_]+):([0-9]+)$/.match(v["ServiceID"])
      if id 
        name = id[1]
        port = id[2]
        if !data.has_key? name
          if v.has_key?("ServiceAddress") && !v["ServicePort"].nil? && !v["ServicePort"].to_s.empty?
            if v.has_key?("ServicePort") && !v["ServicePort"].nil? && !v["ServicePort"].to_s.empty?
              data[name] = "#{ v["ServiceAddress"] }:#{v["ServicePort"]}"
            end
          end
        end
      end
    }
  }

  ns = Namespace.new(data,{})
  result=ERB.new(template).result(ns.get_binding)

  actual = Zlib::crc32(result)

  if actual != last then
    puts "Writing /etc/nginx/nginx.conf"
    puts result
    File.open('/etc/nginx/nginx.conf', 'w') { |file| file.write(result) }
    `/usr/sbin/nginx -s reload`
    last = actual
  end

end

