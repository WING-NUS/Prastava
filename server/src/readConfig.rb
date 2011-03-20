require $HOME+'/server/src/collaborative_filtering'
require $HOME+'/server/src/content_based_filtering'
require $HOME+'/server/src/hybrid'
##########################################################
#  This class's main objective is to read config file and then pass it to 
#  the other classes for generating recommendations
##########################################################

class ReadConfig
  #####################################################
  #This function reads the parameters from initialization file
  #config.ini on the server side
  #####################################################
  
  def read_config_file
		config_hash = {}
    	File.open($HOME+"/server/config.ini") do |file|
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
##################################################################################################
#  This function reads the hash passed to it and assigns parameters with their respective values
#  stored in hash and then passes these parameter for generating recommendation using
#  collaborative filtering
###################################################################################################

  def parse_cf(hash)
  	uid = hash['userid']
    	algo = hash['algo']
    	$minR = hash['minRating'].to_f
    	$maxR = hash['maxRating'].to_f
    	$k_sim_users = hash['k_sim_users'].to_i
    	$k_sim_items = hash['k_sim_items'].to_i
    	puts "Recommendations through Collaborative Filtering :\n"
    	cf_recos = CF.new
    	cf_recos_result = cf_recos.generate_recos(uid, algo)
	return cf_recos_result.slice(0,$k_sim_items)
  end

################################################################################################
#  This function reads the hash passed to it and assigns parameters with their respective values
#  stored in hash and then passes these parameter for generating recommendation using
#  content based filtering
#################################################################################################

  def parse_cbf(hash,given_file)
		File.open($HOME+"/server/data/TextLib/temp","w") do |file|
		file.puts("\"temp_file\"")
		given_file.each{|a| file.puts(a)}
    	end
    	file = $HOME+"/server/data/TextLib/temp"
    	dir = hash['dir']
    	$index_file = hash['index_file']
    	$k_sim_items = hash['k_sim_items'].to_i
    	puts "Recommendations through Content Based Filtering :\n"
    	cbf_recos = CBF.new
    	cbf_recos_result = cbf_recos.generate_recos(file, dir)
	return cbf_recos_result.slice(0,$k_sim_items)
  end


  
#################################################################################################
#  This function reads the hash passed to it and assigns parameters with their respective values
#  stored in hash and then passes these parameter for generating recommendation using
#  hybrid filtering
#################################################################################################
  
  def parse_both(hash,given_file)
		uid = hash['userid'].to_i
    	algo = hash['algo']
    	input_type = hash['input_type']
    	if input_type.eql?("file") then
      		matrix_file = hash['filepath']
    	elsif input_type.eql?("dbase")
      		puts "Database selected...\n"
      		exit()
    	end
    	$minR = hash['minRating'].to_f
    	$maxR = hash['maxRating'].to_f
    	$k_sim_users = hash['k_sim_users'].to_i
    	$k_sim_items = hash['k_sim_items'].to_i
		$switch_threshold=hash['switch_threshold'].to_i
		$content_booster=hash['content_booster='].to_f
		File.open($HOME+"/server/data/TextLib/temp","w") do |file|
		file.puts("\"temp_file\"")
		given_file.each{|a| file.puts(a)}
    	end
    	file = $HOME+"/server/data/TextLib/temp"
    	dir = hash['dir']
    	$index_file = hash['index_file']
    	$k_sim_items = hash['k_sim_items'].to_i
		hybrid_recos = HYBRID.new
    	hybrid_recos_result = hybrid_recos.generate_recos(uid,algo,file,dir)
		return hybrid_recos_result.slice(0,$k_sim_items)
  end


end


