#!/usr/bin/env ruby

require 'json'
require 'uri'
require 'securerandom'
require 'logger'
require 'optparse'


module Logging
  LOG_DIR = "/var/log/nsm/so-elsa"
  LOG_FILE = LOG_DIR + "/elsa_registration_logfile-#{Time.now.to_i}.log"
  unless File.directory? LOG_DIR
    Dir::mkdir LOG_DIR
  end
  
  def logger
    @logger ||= Logger.new(LOG_FILE)
  end
end

class ELSAConfig
  include Logging
  attr_accessor :file, :config
  def initialize(options={})
    defaults = {
      :file => '/etc/elsa_web.conf'
    }
    options = defaults.merge(options)
    @file = options[:file]
  end

  def trim_nodes!
    logger.debug "Trimming nodes."
    self.config['nodes'].keys.each do |key|
      next if key == "127.0.0.1"
      self.config['nodes'].delete(key)
      logger.debug "Removed node: #{key}"
    end
  end
    
  def migrate_conf revision, type
    # Migrate specific entries from a previous config into a new version.
    manifest = {
      "versions" => {
        "1090" => {
          "web" => {
            "apikeys" => {
              "elsa" => "1"
            },
            "version" =>  {
              "Author" => "mcholste",
              "Date" => "2013-08-26 16:05:12 -0400 (Mon, 26 Aug 2013)",
              "Rev" => "1090",
              "Sphinx" => "Sphinx 2.0.7-id64-dev (rel20-r373)"
            },
            "peers" => {
              "127.0.0.1" => {
                "apikey" => "1",
                "url" => "https://127.0.0.1:3154/",
                "username" => "elsa"
              }
            },
            "admin_email_address" => "root@localhost",
            "buffer_dir" => "/nsm/elsa/data/elsa/tmp/buffers/",
          },
          "node" => {
            "stopwords" => {
              "file"=> "/etc/sphinxsearch/sphinx_stopwords.txt",
              "top_n"=> 0,
              "interval"=> 0,
              "whitelist" => []
            },
            "mysql_dir" => "/nsm/elsa/data/elsa/mysql",
            "stats" => {
              "retention_days" => 365
            },
            "min_expected_hosts" => "2"
          }
        },
	"1205" => {
	  "web" => {
            "data_db" =>  {
            "db" => "syslog",
            "username" => "elsa",
            "password" => "biglog",
            },
            "version" =>  {
              "Author" => "mcholste",
              "Date" => "2014-07-17 15:12:58 -0700 (Thu, 17 Jul 2014)",
              "Rev" => "1205",
              "Sphinx" => "Sphinx 2.1.9"
            }
	  }
	}
      }
    }

    self.config = manifest['versions'][revision.to_s][type].merge(self.config)
    logger.debug "Updating #{type} config to revision #{revision}"
  end

  def update_api_key! apikey
    logger.debug "Updating API key."
    self.config['apikeys'] = {"elsa" => "#{apikey}"}
    self.config['peers']['127.0.0.1']['apikey'] = apikey
  end

  def delete_node! node
    logger.debug "Deleting node."
    self.config.delete(node)
  end
    
  def randomize_apikey!
    logger.debug "Randomizing API key."
    new_api_key = SecureRandom.hex
    self.config['apikeys'] = {"elsa" => "#{new_api_key}"}
    self.config['peers']['127.0.0.1']['apikey'] = new_api_key
  end
  
  def parse_conf
    # Strip comments out of the JSON file
    conf_file_stripped = String.new
    File.open(@file).readlines.each do |line|
      conf_file_stripped += line.chomp.gsub(/\t/, '') unless line =~ /^\W*#/
    end

    # Correct any invalid trailing commas in JSON
    conf_file_stripped.gsub! /,}/, "}"
    # Parse JSON config file
    @config = JSON.parse(conf_file_stripped)
  end

  def check_peers(peer_name)
    @config['peers'].member? peer_name
  end

  def write_conf(options={})  
    defaults = {
      :force => nil
    }
    options = defaults.merge(options) 
    new_conf_file = (options[:force] && File.open(@file, 'w' )) ||
      File.open("#{@file}.new", 'w')
    new_conf_file.puts JSON.pretty_generate(@config)
    new_conf_file.close
    logger.debug "Config file written."
  end

  def add_peer(peer_name)
    return nil if check_peers(peer_name)
    @config['peers'][peer_name] = {
      "url"      => "http://127.0.0.1:#{self.next_free_port()}/",
      "username" => "elsa",
      "apikey"   => SecureRandom.hex}
    logger.debug "Added peer: #{peer_name}"
  end

  def next_free_port
    free_port = nil
    ports_used = Array.new
    base_port = 50000
    @config['peers'].each do |key,value|
      ports_used << URI(value['url']).port
    end
    
    until free_port.nil? != true
      free_port = base_port unless ports_used.member? base_port
      base_port += 1
    end
    free_port
  end
end

WEB_CONF_FILE = "/etc/elsa_web.conf"
NODE_CONF_FILE = "/etc/elsa_node.conf"

options = {}
option_parser = OptionParser.new do |opts|
  opts.on("-s", "--status-report") do
    options[:report] = true
  end
  opts.on("-f", "--force") do
    options[:force] = true
  end	
  opts.on("-p", "--next-port") do
    options[:next_port] = true
  end
  opts.on("-r", "--register") do 
    options[:register] = true
  end
  opts.on("-p", "--peer-name PEERNAME") do |peername|
    options[:peername] = peername
  end
  opts.on("--update-apikey APIKEY") do |apikey|
    options[:apikey] = apikey
  end
  opts.on("--random-apikey") do |apikey|
    options[:randomapikey] = true
  end
  opts.on("--migrate-web REVISION") do |revision|
    options[:migrate_web] = revision
  end
  opts.on("--migrate-node REVISION") do |revision|
    options[:migrate_node] = revision
  end
  opts.on("--trim-nodes") do
    options[:trim_nodes] = true
  end
  opts.on("--migrate-web-1205") do
    options[:migrate_web_1205] = true
  end

end
option_parser.parse!

if options[:migrate_web_1205]
  current_conf = ELSAConfig.new(:file => WEB_CONF_FILE)
  current_conf.parse_conf
  current_conf.delete_node! "nodes"
  current_conf.delete_node! "version"
  current_conf.migrate_conf 1205, "web"
  current_conf.write_conf(:force => true)
end

if options[:randomapikey]
  current_conf = ELSAConfig.new(:file => WEB_CONF_FILE)
  current_conf.parse_conf
  current_conf.randomize_apikey!
  current_conf.write_conf(:force => true)
end

if options[:migrate_web]
  current_conf = ELSAConfig.new(:file => WEB_CONF_FILE)
  current_conf.parse_conf
  current_conf.migrate_conf options[:migrate_web], "web"
  current_conf.write_conf(:force => true)
end

if options[:migrate_node]
  current_conf = ELSAConfig.new(:file => NODE_CONF_FILE)
  current_conf.parse_conf
  current_conf.migrate_conf options[:migrate_node], "node"
  current_conf.write_conf(:force => true)
end

if options[:trim_nodes]
  current_conf = ELSAConfig.new(:file => WEB_CONF_FILE)
  current_conf.parse_conf
  current_conf.trim_nodes!
  current_conf.write_conf(:force => true)
end

if options[:apikey]
  current_conf = ELSAConfig.new(:file => WEB_CONF_FILE)
  current_conf.parse_conf
  current_conf.update_api_key! options[:apikey]
  current_conf.write_conf(:force => true)
end

if options[:register]
  current_conf = ELSAConfig.new(:file => WEB_CONF_FILE)
  current_conf.parse_conf
  current_conf.add_peer(options[:peername])
  current_conf.write_conf(:force => true)
  new_peer = current_conf.config['peers'][options[:peername]]
  puts "#{URI(new_peer['url']).port},#{new_peer["apikey"]}"
end
