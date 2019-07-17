 #! /bin/bash

 # THIS SCRIPT IS USED AT YOUR OWN RISK
 #THIS SCRIPT ASSUMES YOU HAVE AWS CLI installed, if not use sudo apt-get install awscli -- or see : https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
 #THIS SCRIPT IS MADE TO ADD THE LAST DAY PARTITION AND THEN QUERY ALL THE DATA FROM THIS LAST DAY
 #
 #it assumes partition is in s3://<BUCKETNAME>/Year/month/day/data.file format
 currentday=$(date +"%dY/%m/%d") #gets current day in 2019/08/01 format
 previousday=$(date -d "-1 day" +"%Y/%m/%d") #gets previous day in 2019/07/31 format
 DATABASE="testdb" #name of my Athena database
 TABLENAME="testtable" #name of my Athena table in said database
 MainQuery="Select * from $DATABASE.$TABLENAME where year=$(date +"%Y") and month=$(date +"%m") and day>=$(date -d "-1 day" +"%d")"  #use this for the main query at the end which will query all the data from yesterdays partition that will be added
 queryString="ALTER TABLE  $DATABASE.$TABLENAME ADD PARTITION (dt = '$previousday') ;" #use this query to add the partitions to the base table before the main query happens

#query for adding the partitions for the previous day. 
# if this is the first time you are running this query you may want to run the following command first to load all previous days partitions, warning if you have 10s of thousands of partitions this could cause issues, you may have to go through each one manually with a for loop.
#
#
# result=$(aws athena start-query-execution --query-string "msck repair table $DATABASE.$TABLENAME" --result-configuration "OutputLocation=s3://soaringsafaris/outputresults/")
# echo $result
#
#

#
# THIS RUNS THE ADD PARTITION command. THE OUTPUT LOCATION IS THE S3 LOCATION WHERE YOU WILL FIND THE RESULTS OF YOUR DATA.
#  RESULT RETURNS THE QUERY id OF THE query
result=$(aws athena start-query-execution --query-string "$queryString" --result-configuration "OutputLocation=s3://soaringsafaris/outputresults/")
echo $result #output the query ID for queryString

# halts the script for 5s to ensure the partition is added and the query completes succesfully, before running main script
sleep 5


if [ -n "$result" ]
then
	#
	# THIS RUNS THE MAIN QUERY. THE OUTPUT LOCATION IS THE S3 LOCATION WHERE YOU WILL FIND THE RESULTS OF YOUR DATA.
	#
	result=$(aws athena start-query-execution --query-string "$MainQuery" --result-configuration "OutputLocation=s3://soaringsafaris/outputresults/")
	echo $result #output the query ID for MainQuery
fi