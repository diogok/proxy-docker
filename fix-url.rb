#!/usr/bin/env ruby

require 'small-setup'

@host = ENV['HOST'] || `hostname -I | awk '{ print $1 }'`.gsub("\n","")
@etcd = ENV['ETCD'] || "http://#{@host}:4001"
@prefix = ENV['PREFIX'] || ""

r = http_get("#{@etcd}/v2/keys/#{@prefix}?recursive=true")
data = nodes2obj(r["node"]["nodes"],"/")


data.keys.each {|k|
    if data[k].has_key?("host") && data[k].has_key?("port") && data[k].has_key?("name") then
        url =  "http://#{@host}/#{data[k]["name"]}"
        http_put("#{@etcd}/v2/keys/#{@prefix}#{k}/url","value=#{url}")
    end
}

