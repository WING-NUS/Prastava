require $HOME+'/server/src/sim_measure'
require 'logger'  
require $HOME+'/server/src/collaborative_filtering'
require $HOME+'/server/src/content_based_filtering'


#Switch threshhold is the average number of ratings done bu user
#it helps in  choose between cascade and weighted hybrid
$switch_threshold=30.0 

#this meansure tell the weightage to be given to "content" in cascade filtering
$content_booster=0.4   

##########################################################
# This class generates recommendation using Hybrid Filtering
##########################################################

class HYBRID < CF

  #####################################################################
  #This function generates the final recommendations based on HYBRID
  #####################################################################
	def generate_recos(uid,algo,filename,dir)
		obj=CBF.new
		res=obj.search(filename,$index,dir)
	    if(decide()==true)
			return cascade_hybrid(uid,algo,filename,res)
		else
			return weighted_hybrid(uid,algo,filename,res)
		end
	end
	
	##############################################################
	#In weighted hybrid the content gets more preference than 
    #collaborative filtering as the matrix is sparse matrix
    ###############################################################
	
	def weighted_hybrid(uid,algo,filename,content)
		alpha=($total_num.to_f)/(2.0*$switch_threshold*($userlist.length.to_f))
#		alpha=0.7
		beta=1.0-alpha
		cf_obj=CF.new
		res=cf_obj.generate_recos(uid,algo)
		for index in 0...res.size
		   res[index][1]=alpha*res[index][1] + beta*content[res[index][0]].to_f
        	end
		q=res.sort{|a,b| b[1]<=>a[1]}
		return res
	end
       ###############################################################	
       #In cascade Filtering first k nearest neighbours are choosed and then 
       #items seen by them are given a rating based on both content and
       #collaborative filtering		
       ###############################################################	
	def cascade_hybrid(uid,algo,filename,content)
		  sim_array = top_k_users($user_hash[uid.to_s],algo)
		  pred={}
    	$itemlist.each {
		  |item|
	  	if($seen[item]==nil)
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
			pred[item]=(pred[item]*(1.0-$content_booster)+content[item].to_f*$content_booster)
		end
		  }
		  res=pred.sort{|a,b| b[1]<=>a[1]}
		  return res
	end
    ##############################################
	#This fucntiom is just to decide which hybrid
	#to be used weighted or cascade.
	##############################################
		
	def decide
		factor=($total_num.to_f)/($userlist.length.to_f)
		if(factor>$switch_threshold)
			return true
		else
			return false
		end
	end
end
