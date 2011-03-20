########################################
#This class contains general functions to be performed on arrays
########################################
class Array
  #############################
  #It returns the sum of element of array
  #############################
  def sum
    inject( 0 ) { |sum,x| sum+x }
  end
  #################################
  #It returns the sum of the squares of element of array
  #################################
  def sum_square
    inject( 0 ) { |sum,x| sum+x*x }
  end

  #################################
  #It returns the mean of the element of array
  #################################
  def mean
    sum / size
  end
  #################################################
  #This function overloads the multiply sign and return the dot product of two arrays
  #################################################
  def *(other) 
    ret = []
    return nil if !other.is_a? Array || size != other.size
    self.each_with_index {|x, i| ret << x * other[i]}
    ret.sum
  end
end


 ########################################
 #This class contains algorithms for similarity analysis
 ########################################
class Sim_measure
   #################################################
   #This function returns the cosine similarity between two arrays.
   #################################################
  def cosine_sim (vector1, vector2,extra_vector)
    magnitude1, magnitude2 = extra_vector.sum_square, 0.to_f
    denominator, numerator = 0.to_f, 0.to_f
    magnitude1 = vector1.sum_square+extra_vector.sum_square
    magnitude2 = vector2.sum_square
    denominator = Math.sqrt(magnitude1 * magnitude2)
    numerator = vector1 * vector2
    if denominator != 0 then
      cos_sim = numerator / denominator
    else
      cos_sim = 0
    end
    return cos_sim
  end
 #################################################
 #This function returns the pearson similarity between two arrays.
 #################################################
  def pearson_corr (vector1, vector2,extra_vector)
    sum1 = vector1.sum+extra_vector.sum
    sum2  = vector2.sum
    r = 0.to_f
    num = ((vector1.size+extra_vector.size) * (vector1*vector2)) - (sum1 * sum2)
    den = Math.sqrt((vector1.size+extra_vector.size) * (vector1.sum_square+extra_vector.sum_square) - sum1 * sum1) * Math.sqrt((vector2.size * vector2.sum_square) - sum2 * sum2)
    if den != 0 then
      r = num/den
    else
     r = 0
    end	
  end
end



