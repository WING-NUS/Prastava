$HOME
############################################################ 
#This is the client program.
#
#
# Copyright  by Tarun Kumar, Himanshu gahlot, Dr Min yen kan.
# All rights reserved.
# See LICENSE.txt for permissions.
#
#The program reads user parameters from initialization file 
#config.ini and passes that in the form of hash to server
#which in turn sends the recommendations based on the 
#inputed parameter back to the client.
##########################################################



require 'soap/rpc/driver'  

$URL="http://localhost:14576/"
$HOME=ARGV[0]
#############################################################
#This Function reads the parameters from initialization
#file and return the hash containing all parameter with their 
#corresponding values.
#############################################################
 def read_config_file
 	config_hash = {}
    	File.open($HOME+"/client/config.ini") do |file|
     		 while !file.eof?
        		line = file.readline
        			if line =~ /^#/ or line == "\n"
	        			next
        			end
        		(parameter, value) = line.split("=")
        		config_hash[parameter] = value.chomp
      		end
    	end
    	config_hash
  end
 
 ########################################################
 #If option is different then collaborative filtering
 #
 #Then content file is read from the specified location 	
 #and stored in the array.   	
 ##########################################################
 config_hash=read_config_file()
 given_file=[]
 if(config_hash['option']!='1')
	File.open($HOME+"/"+config_hash['user_input_file']) do |file|
        	while !file.eof?
			line = file.readline
			given_file<<line
	  	end
	end
 end
 ######################################################
 #Connection to Server 
 #  
 #Presently the connection settings are for local host.
 #change the setting to your settings.	
 #######################################################
 $URL=config_hash['URL']   #reading the url from client config file
 driver = SOAP::RPC::Driver.new($URL, 'urn:PrastavaServer')  
 driver.add_method('generate_recommendation','hash','given_file')  
 res=driver.generate_recommendation(config_hash,given_file)

 for index in 0...res.size
	printf("%s has rating %.3f\n",res[index][0].to_s,res[index][1].to_f)
 end
