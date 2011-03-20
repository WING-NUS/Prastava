#--
# Copyright  by Tarun Kumar, Himanshu gahlot, Dr Min yen kan.
# All rights reserved.
# See LICENSE.txt for permissions.
#
 
 
 
$HOME=ARGV[0]
 
 
 require 'logger'  
 require 'soap/rpc/standaloneServer'  
 require  $HOME+'/server/src/readConfig'
 require  $HOME+'/server/src/collaborative_filtering'
 require  $HOME+'/server/src/content_based_filtering'
 require 'rubygems'
 require 'ferret'
 require 'find'
 require  $HOME+'/server/src/stemmable'

 $index
 
$HOME   #global variable for home directory
$port=14576
$host_name='127.0.0.1'
 ########################################################
 #This Function needs to be called only at the time of
 #server start.It creates indexes of the files required
 #for content based filttering and reads the rating file
 #for collabrative filtering.
 ####################################################### 

$HOME=ARGV[0]
puts $HOME
 def initialization()
  include Ferret
	init_cbf=CBF.new
	init_cf=CF.new
	config = ReadConfig.new
	hash=config.read_config_file
  $index_file = $HOME+"/"+hash['index_file']	
	matrix_file = $HOME+"/"+hash['filepath']
  $index = Index::Index.new(:path => $index_file)
  $index = Index::Index.new(:default_field => 'content')
	dir = $HOME+"/"+hash['dir']
  $port=hash['port'].to_i
  $host_name=hash['host_name']
  #index files
	init_cf.read_from_file(matrix_file)
  $index = init_cbf.gen_index(dir, $index)
 end
 

  initialization()
class MyServer < SOAP::RPC::StandaloneServer
  
    def initialize(* args)  
    	 super  
     	add_method(self, 'generate_recommendation', 'hash','given_file','my_item_hash')  
     	#create a log file  
     	@log = Logger.new($HOME+"/server/prastava.log")  
    end  

    ###############################################################
    #This function takes in input parameters(described below)  
    #from the client side and generates the 
    #recommendations. 
    #
    #hash--It contains various parameters required for  recommendatios
	#for eg Number of nearest neighbours algo Filtering to be used etc 
	#
    #
    #given_file-It is the array containing the file which
    #is to be used for content based comparison in 
    #content based filtering
    #
    #			 		
    ####################################################################   

    def generate_recommendation(hash,given_file)  
        t = Time.now  
        @log.info("userid #{hash['userid']} logged on #{t}")  
	      puts "Reading input parameters from config.ini...\n"
        config = ReadConfig.new
	      config.read_config_file.each_pair{|a,b| hash[a]=b}
        case hash['option'] 
          when '1'
            puts "Using only Collaborative Filtering\n"
            @log.info("Recommendations through Collabrative for userid #{hash['userid']}")
            res=config.parse_cf(hash)
            t = Time.now  
            @log.info("userid #{hash['userid']} logged out on #{t}")
            return res
          when '2'
            puts "Using only Content Based Filtering\n"
            @log.info("Recommendations through Content based Filtering for userid #{hash['userid']}")
            res= config.parse_cbf(hash,given_file)
            t = Time.now  
            @log.info("userid #{hash['userid']} logged out on #{t}")
            return res
          when '3'
            @log.info("Recommendations through both Collaborative and Content based Filtering for userid #{hash['userid']}")
            puts "Using both Collaborative and Content Based Filtering\n"
            res=config.parse_both(hash,given_file)
            t = Time.now  
            @log.info("userid #{hash['userid']} logged out on #{t}")
            return res
          else
            puts "Invalid value of parameter--option"
            @log.info("Invalid value of parameter--option bu userid #{hash['userid']}")
            t = Time.now  
            @log.info("userid #{hash['userid']} logged out on #{t}")
            exit()
          end
        end  
    end  



 t = Time.now  
 server = MyServer.new('PrastavaServer','urn:PrastavaServer',$host_name,$port)  
 trap('INT') {server.shutdown}  
 server.start
