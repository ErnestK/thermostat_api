# Thermostat api                 
                 
## Task description                 
Many apartments have a central heating system and due to different room isolation properties                                  
it's not easy to keep the same temperature among them. To solve this problem we need to                 
collect readings from IoT thermostats in each apartment so that we can adjust the temperature                 
in all the apartments in real time.                 
The goal of this task is to build a basic web API for storing readings from IoT thermostats                 
and reporting a simple statistics on them.                 
We are going to have two models with the following properties:                 
Thermostat:                 
- ID                 
- household_token (text)                 
- location (address)                 
Reading:                 
- ID                 
- thermostat_id (foreign key)                                  
- number (sequence number for every household)                                  
- temperature (float)                                  
- humidity (float)                 
- battery_charge (float)                 
The API consists of 3 methods. In addition to its own parameters each method accepts a                 
household token to authenticate a thermostat. Serialize an HTTP response body using                 
JSON. The methods are:                 
1. POST Reading: stores temperature, humidity and battery charge from a particular                 
thermostat. This method is going to have a very high request rate because many IoT                 
thermostats are going to call it very frequently and simultaneously. Make it as fast as                 
possible and schedule a background job for writing to the DB (you can use Sidekiq for                 
example). The method also returns a generated sequence number starting from 1 and every                 
household has its own sequence.                 
                 
2. GET Reading: returns the thermostat data using the reading_id obtained from POST                 
Reading. The API must be consistent, that is if the method 1 returns, the thermostat data                 
must be immediately available from this method even if the background job is not yet                 
finished.                 
3. GET Stats: gives the average, minimum and maximum by temperature, humidity and                 
battery_charge in a particular thermostat across all the period of time. Again, make sure                 
this method is consistent in the same way as method 2. For extra points, make it execute in                 
O(1) time.                 
For simplicity, you can seed the DB with different thermostats containing household tokens                 
and locations. Make sure your code is properly tested with RSpec as well. You can use any                 
tools and gems to build and optimize your API. For extra points, handle bad requests with a                 
JSON error message and a non success response code.                 
                           
## How to install section                  
To install project you should                     
- clone project
- execute `cd thermostat_api`  in console            
- execute `docker-compose up -d` in console to run all containers             
                     
## How to run app                     
1. Since in the seeds we created a thermostat with token 1, we can create readings like this              
`curl --location --request POST '0.0.0.0:3000/readings?temperature=22&humidity=32&battery_charge=34&household_token=1'`                             
2. That's how we can get readings              
`curl --location --request GET '0.0.0.0:3000/readings/1'`              
3. That's how we can get stats              
`curl --location --request GET '0.0.0.0:3000/stats'`              
                    
## How to run specs                     
After you have completed step "How to install section", you should                     
- execute `docker-compose exec app bundle exec rspec` in console - to run all tests                     
- execute `docker-compose exec app bundle exec rubocop` in console - to run checking cops                     
                     
## Approach description                     
1. POST Reading: The main condition was for the endpoint to work quickly, but at the same time return the id and number.                     
The service which works in this action is **very fast**.                     
- He get from Redis (hash collection) dictionary next id for this entry from all readings and the number for this particular token (since we using sequence for each token ).                     
- Then create reading_value and put it in ither redis collection( right now without any validation, cause we should do it really fast,                      
we validate/process it later).                     
- Then it launches the job in the sidekick.                     
- Then it render id and number in the response.                     
                     
Read/put from/to Redis hash collection operation cost O(1) complexity.              
              
1.2 Sidekiq job              
- selects an entry from the cache              
- validates it              
- calculates stats data and updates the dictionary( Redis collection ) (so that when you need statistics you do not have to calculate it across the entire pg table)              
- writes to postgress              
              
if an error occurs, it writes to the log              
                                                       
2. GET Reading: The main condition for the end point,                     
get data from both the main table and the cache, which Redis has not yet processed.                     
                     
We have a cache (Redis), in which we looking for data and if we do not find the data there, then we look in the main table (PG)                              

Read from Redis hash collection operation cost O(1) complexity.                     
If we dont find data there we look for it in postgres whcih cost O(n) complexity. ( depending on count of readings(n) in table )                     
                                          
3. GET Stats: Main end point condition,                     
get data from both the main table and the cache that Redis has not yet processed.                     
Also do it fast.                     
                     
- Get data from dict( 1.2 point ) , which store data for all data from pg.                     
- Get data from id dict about max id which we have in cache                     
- Get data from stat dict about last id which we store in stat dict                     
- Move between that range last_id+1..max_id, and find all data in cache, calc stat data for that entry and aggregate it with stat dictionary ( but not rewrite stat dict )                     
- render it                     
                     
Read from Redis hash collection operation cost O(1) complexity.                                   
Iterate through data in cache cost O(last_id+1..max_id),                                    
data in cache which we dont processed yet.                                   

### Fast json for serilizers                       
Using gem fastjson for serialization.                       
It is 10 times faster than the activemodel                       

### Service           
The main place for storing business logic is in services.                      
Gem dry-monads was used           
And they are built according to several rules!           
- Each of them has only one public calling method `call`.                      
- Verb naming           
- Each of them works in a monad           
- Each of them returns Success or Failure           
- Doesn't crash on error (we can always expand the result and process / render it and not just show 500 code)           
- If the previous step led to failure, then further we monad does not work in vain
           
So we get that we can easily associate them with each other.
It is also more convenient to test and maintain the code.    
