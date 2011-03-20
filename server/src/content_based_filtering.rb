#!/usr/bin/env ruby
require 'rubygems'
require 'ferret'
require 'find'
require $HOME+'/server/src/stemmable'

$num_files = 10
$hash_file={}
$index_file = "../index/ferret_test"

##############################################
#Below is the list of all stop words.
##############################################


$stop_words = "a about above across after afterwards again against all almost alone along already also although always am among amongst amoungst amount an and another any anyhow anyone anything anyway anywhere are around as at back be became because become becomes becoming been before beforehand behind being below beside besides between beyond bill both bottom but by call can cannot cant co computer con could couldnt cry de describe detail do done down due during each eg eight either eleven else elsewhere empty enough etc even ever every everyone everything everywhere except few fifteen fify fill find fire first five for former formerly forty found four from front full further get give go had has hasnt have he hence her here hereafter hereby herein hereupon hers herself him himself his how however hundred i ie if in inc indeed interest into is it its itself keep last latter latterly least less ltd made many may me meanwhile might mill mine more moreover most mostly move much must my myself name namely neither never nevertheless next nine no nobody none noone nor not nothing now nowhere of off often on once one only onto or other others otherwise our ours ourselves out over own part per perhaps please put rather re same see seem seemed seeming seems serious several she should show side since sincere six sixty so some somehow someone something sometime sometimes somewhere still such system take ten than that the their them themselves then thence there thereafter thereby therefore therein thereupon these they thick thin third this those though three through throughout thru thus to together too top toward towards twelve twenty two un under until up upon us very via was we well were what whatever when whence whenever where whereafter whereas whereby wherein whereupon wherever whether which while whither who whoever whole whom whose why will with within without would yet you your yours yourself yourselves"
$index

#####################################################################
# This class generates recommendation using content based filtering
#####################################################################
class CBF

  include Ferret
  #####################################################################
  #This function generates the final recommendations based on CBF
  #####################################################################
  def generate_recos(filename, dir)
  	score_hash = search(filename, $index,dir)
    	puts "\nProcessing complete "
    	return score_hash.sort{|a,b| b[1]<=>a[1]}
  end

 #######################################################################################
 #This function creates index of the file stored in database. It is called at the time of server startsand may take time if there are more files in database
 #######################################################################################
  def gen_index (dir, index)
  	count=0
    	Find.find(dir) do |path|
      		count+=1
      		if FileTest.file? path
        		 File.open(path) do |file|
				(a,str,b)=file.readline.split("\"")
				$hash_file[path.to_s]=str 	 
          			index.add_document :file => path,
            			:content => file.readlines
        		end
      		end
    	end
   	 return index
  end

  ###############################################################
  #This function compares the file given by user with the other file in the directory(using index)
  ###############################################################
  def search (filename, index,dir)
  	score_hash = {}
	res={}
    	my_file = File.new(filename)
    	my_string = my_file.read
    	my_string = to_terms(my_string)
    	count = 0
    	index.search_each(my_string) do |doc, score|
      		count+=1  
      		score_hash[(index[doc]['file']).to_s] = score.to_f
    	end
        score_hash.each_pair{|a,b| res[$hash_file[a.to_s].to_s]=b.to_f}
	if(res["temp_file"]==nil)
		res["temp_file"]=1
	end
	conversion=res["temp_file"]
	for index in 0...$itemlist.length
		temp=$itemlist[index].to_s
		if(res[temp]==nil)
			res[temp]=$minR.to_f
		else
			res[temp]=$minR.to_f+($maxR-$minR).to_f*(res[temp]/conversion)
		end
	end
	return res
  end

  #####################################
  #This function removes all non letter and reject stop words
  #####################################
  def to_terms (my_string)
    	terms_list = my_string.downcase.gsub(/(\s|\d|\W)+/u,' ').rstrip.strip.split(' ').reject{|term|$stop_words.include?(term)}#.each {|term| term = term.stem}
    	count = 0
    	string = ""
    	terms_list.each do|term|
      		count+=1
      		term = term.stem
      		string = string + " " + term
    	end
    	string
  end


end


