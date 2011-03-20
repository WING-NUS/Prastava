Prastava README

This software is copyrighted 2009 by Himanshu Gahlot, Tarun Kumar 
and Min-Yen Kan.
This program and all its source code is distributed 
under the terms of the GNU General Public License (or the Lesser
GPL).

    Prastava is a free software: you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    Prastava is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with Prastava.  If not, see
    <http://www.gnu.org/licenses/>.	
For more information see LICENSE.txt

----------------------------------------------------------------------
Prerequisites:

- Ruby - Please ensure that you havae ruby (at least version XX) on
	 your system.  For both Linux and Windows, ruby can be
	 obtained from here: http://www.ruby-lang.org/en/downloads/

- Ferret - You also need to install the ferret ruby gem to your system.

	 $ gem install ferret-0.11.6-mswin32.gem

                or
	
	(The one distributed with this system)
	$ gem install prastava_v1.0/ferret-gem-installation/ferret-0.11.6-mswin32.gem

Congratulations, you have the necessary software to run Prastava.  Now
that it is installed, follow the below guidelines to run the code.

----------------------------------------------------------------------
Instructions to run Prastava:

1. Server Set Up

1a. Edit the server configuration file. The appropriate parameters
    need to be set in the config file on the server side located at
    (set HOME to be the path of directory in which prastava is kept)
    prastava_v1.0/server/config.ini
    (The description of all parameters is written in config file)

1b. After setting all relevant parameters and the correct port, run the
    server code.  The command to start the server is :

    ruby server.rb  "path of server directory"
    

    For example

    ruby server.rb   "/home/user/software/prastava_v1.0"

                or

    ruby server.rb   "C:/Program Files/prastava_v1.0"

    In the above example the path to the server directory is
    "/home/user/software/prastava_v1.0" and "C:/Program Files/prastava_v1.0"
    repectively.

    Note: When the server is run first time it will take longer
    because the system will need to first index the input files and
    read in the the matrix files, but all the subsequent runs will be
    much more efficient.

    When the server is ready it will print "done" on standard output.

2. Client Set Up

You now have the server running.  The final steps are to correctly
configure and run the client.

2a. Set the appropriate parameters and server address in the client
    config file located at: prastava_v1.0/client/config.ini.
    The description of all parameters is written in the config file.
    
	
2b. Run the client.  Use the command: 

    ruby client.rb "path of client directory"
    
   
    For example

    ruby client.rb   "/home/user/software/prastava_v1.0"

		or 

    ruby client.rb   "C:/Program Files/prastava_v1.0"
			
    In the above example the path to the client directory is
    "/home/user/software/prastava_v1.0" and "C:/Program Files/prastava_v1.0"
    repectively.

     Recommendations will then be generated on standard output.

-----------------------------------------------------------------------
Files:

client/							- The client side application
	/config.ini 				       	- Configuration file for providing 
							  client side input parameters.
				
	/src/  					        - The ruby codes for client 
		/client.rb 				- The main code which passes input
							  parameters to the server for
							  generation of recommendations and
					    		  prints them to STDOUT.
								
       /given.txt/                                      - This is the file which contain keywords 
							  of user preference.The file similar this
							  file will be searched using content based
							 			  
								 
server/							- The server side application
	/config.ini 					- Configuration file for providing 
							  server side input parameters.
				
				
	/README.txt					- This file.
				
	/src/       					- The ruby codes for server.
	
		/server.rb  	   	 		- Main file for server side application
							  which receives input parameters from 
							  client side and using other settings 
							  from config.ini file generates 
							  recommendations.
									  
		/collaborative_filtering.rb 		- Code for calculating recommendations 
							  based on collaborative filtering 
							  (using a rating matrix).
									  
		/content_based_filtering.rb         	- Code for calculating recommendations
							  based on content based filtering 
							  using the ferret indexing and searching
							  library.
									  
		/hybrid.rb				- Code for generating recommendation based 
							  on both collaborative and content
							  based filtering.
									  
		/readConfig.rb   		        - Code for reading the config.ini file.
		
		/stemmable.rb           	      	- Code for stemming individual words 
						          (used in content based filtering) 
					       	          using the Porter Stemmer Algorithm.
										  
		/sim_measure.rb             	        - Code implementing various similarity 
							  measure algorithms.
	
	/ferret-gem-installation/			- contains ferret gem installation file

		/ferret-0.11.6-mswin32.gem  		- Ferret gem installation file.
					
	/index/						- Index files for ferret.
		
		/ferret_test            		- The ferret indexing directory.
				
	/data/						- Directory containing all the data files used
							  in collaborative and content based filtering.
									  
		/u.data 				- The movie lens data set containing ratings 
							  of users on movies.


------------------------------------------------------------------------------------
Demonstration details

The Prastava toolkit contains data from the MovieLens project to
demonstrate its functionality.  For those who are unfamiliar with the
MovieLens dataset and project, please visit their site:

http://movielens.umn.edu

------------------------------------------------------------------------------------
To use Collaborative Filtering

Ensure that the rating database is in the following triple format: 

"Item ID/Name" "UserID/Name" "Rating"

Each of these fields should be separated by a space and enclosed in
quotes.  Each new rating should be on a separate line.

For example, "Slumdog Millionaire" "Tarun" "5" means that the user "Tarun" 
gave a rating of "5" to item "Slumdog Millionaire".

Note: "Item name" ,"User Id/Name" cannot contain quotes within
them (quotes for clarity).

See sample file located at:
server/data/u.data

--------------------------------------------------------------------------------------
To use Content Based Filtering
 
The client will give a file which should contain keywords similar to
which he wants recommendations.

The content to be used for Content based filtering needs to be stored
in a separate directory, where each item is described by an individual
file.  While the files can have any name, each file's first line must
contain the item name of which it describes.  Ensure that the first
line's item name is enclosed in quotes.  

For example, the sample content distributed with Prastava is located
at server/data/TextLib.  One of the files there, titanic.txt contains
the first line "Titanic (1997)" which denotes the item name and its
subsequent lines give its content based description.

----------------------------------------------------------------------------------------
Troubleshooting				

If you find any difficulty in installation, or suggestions, please
email us at:

Tarun Kumar     -  tar.iiita@gmail.com
Himanshu gahlot -  himanshu.gahlot86@gmail.com
