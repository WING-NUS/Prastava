require $HOME+'/server/src/sim_measure'
require 'logger'  
 
$seen={}                  #This hash contains the items which have been seen/rated by the user.
$minR = 1.0               #minimum rating in the rating file
$maxR = 5.0		  		  #maximum rating in the rating file	
$k_sim = 10		  		  #Number of recommendations to be generated	
$user_mean_ratings=[]     #It contains the mean rating for each user
$data=[]                  #It contains whole database
$user_total_count=[]	  #count of the items rated by the user	
$userlist=[]              #List of the user corresponding to their integer user id
$itemlist=[]		  	  #List of the items corresponding to their integer item id
$item_hash={}             #Hash which hashes each item with a unique item id. 
$user_hash={}             #Hash which hashes each userid with a unique user id 
$total_num                #count of total number of ratings



##########################################################
# This class generates recommendation using collaborative filtering.
##########################################################
class CF
 ######################################
 #This function returns the final result of the items
 #recommended by the system to the user arranged in
 #in decreasing orderof their rating
 #######################################
 
  def generate_recos(uid, algo)
    sim_array=[]
	uid=$user_hash[uid.to_s]
	if(uid==nil)
		return sim_array #returning nil array;
	end
	uid=uid.to_i
    	printf "Processing..."
    	sim_array = top_k_users(uid, algo) # A two dimensional array containg tok k users and their similarity values
    	pred = {};res={}
    	count=-1
    	$itemlist.each {
		  |item|
	  	if($seen[item]==nil)
		 	count+=1
		  	num=0.to_f;den=0.to_f
		  	for index in 0...sim_array.length
				den+=sim_array[index][1].to_f
		 		tmp=($data[sim_array[index][0]][$item_hash[item.to_s]].to_f-$user_mean_ratings[sim_array[index][0].to_i].to_f)
		 		num+=sim_array[index][1].to_f*tmp 
		 	end
			factor=0.0
			if(den!=0.0)
				factor=num/den
			end
			pred[item]=$user_mean_ratings[uid].to_f+factor
			if(pred[item]>1.0)
				pred[item]=1.0
			end
		  	pred[item]=$minR+($maxR-$minR)*(pred[item])
	  	end
	}	
		puts "\nProcessing complete"
       		res=pred.sort{|a,b| b[1]<=>a[1]}
		return res
  end

####################################################
#This function returns the top "k" nearest neighbours
#to the user with userid "uid" using the algo "algo".
#####################################################

 def top_k_users(uid, algo) 
	empty=[]
	if(uid==nil)
		return empty #returning nil array;
	end
    my_ratings_id, num, sim_hash, similarity =  [], -1, {}, Sim_measure.new
	$seen={}
	for pos in 0...$data[uid].length
		if(!($data[uid.to_i][pos].nil?))
			my_ratings_id<<pos
			$seen[$itemlist[pos]]=1
		end
	end	
	
    	for j in 0...$userlist.length
		if(j!=uid)
			target=j
			other_ratings=[]
			my_ratings=[]
			extra_vector=[]
			#here put code
			for i in 0...my_ratings_id.length
		    		mark=my_ratings_id[i]
				if(!($data[target][mark].nil?))
					my_ratings<<$data[uid][mark]
					other_ratings<<$data[target][mark]
				else
					extra_vector<<$data[uid][mark]
				end
			end
			case algo
			when "cosine"
				 sim_hash[target] = similarity.cosine_sim(my_ratings, other_ratings,extra_vector)
			when "pearson"
				sim_hash[target] = similarity.pearson_corr(my_ratings, other_ratings,extra_vector)
			else
				puts "Wrong value for parameter 'algo'. Program will exit."
            			exit()
			end
		end
       end
    	res=sim_hash.sort{|a,b| b[1]<=>a[1]}  # Return a two dim array of top k similar users
	res=res.slice(0,$k_sim_users)
    	return res
  end

  
  


  
  #########################################################
  #This function reads the data from file stores at "path"
  #and store it in double dimension array $data and assigns
  #integer ids to item and users which are stored in hashes
  #item_hash and user_hash. 
  ##########################################################
  
  def read_from_file(path)

	##################################################################
 	#
 	# The Format of the rating file should be as follows:
 	#
 	# Respective fiels need to be enclosed in quotes
  	# and seperated by space.
  	#
  	# "item1" "user1" "rating1"
  	# "item2" "user2" "rating2"
	#Here it represent the items "item1" and "item2" are given a rating of 
  	# "rating1" and "rating2" by user "user1" and "user2" respectively.  
  	#
  	####################################################################
	$total_num=0
	count=-1;coun=-1
  	File.open(path) do |file|
		while !file.eof
		(a,item,b,user,c,rating,d)=file.readline.split("\"")
			rating =(rating.to_f-$minR)/($maxR-$minR) #projecting the rating to 0..1 scale
			$total_num+=1;
			if($item_hash[item]==nil)
				count+=1
				$item_hash[item]=count
				$itemlist[count]=item
			end
			if($user_hash[user]==nil)
		       	        coun+=1
				$data[coun]=[]
				$user_total_count[coun]=0
				$user_hash[user]=coun
				$userlist[coun]=user
			end
			$data[$user_hash[user]][$item_hash[item]]=rating.to_f
			$user_mean_ratings[$user_hash[user]]= $user_mean_ratings[$user_hash[user]].to_f+rating.to_f
			$user_total_count[$user_hash[user]]+=1
		end
	end
	for index in 0...$userlist.length
		$user_mean_ratings[index]=$user_mean_ratings[index].to_f/$user_total_count[index].to_f
	end
	puts "done"
  end
   
  
  


end
