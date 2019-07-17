#!/usr/bin/python3
import boto3
#for more info visit
#-> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Client.select_object_content
query = boto3.client('s3')
resp = query.select_object_content(
	Bucket='<BUCKETNAME>',
	Key='tmpdata/20190209_075318_00001_2jy98_f4be268f-6396-47c8-bdaa-a088ba95974b.gz',
	Expression=" Select * from s3object ",
	ExpressionType='SQL',
	InputSerialization={
	"CSV":{'FileHeaderInfo':'USE',},},
	OutputSerialization={'JSON':{}},
	)
#returns {'ResponseMetadata': {'RequestId': '484102AF1699E9FA', 'HostId': 'j1ORFvvxooNpZx0ZbuGy7oW5iY8zci6A4OnqV9T3yVuwXBPuSRcfUduSVDx8Z5+5l93ubYx25D4=', 
#'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amz-id-2': 'j1ORFvvxooNpZx0ZbuGy7oW5iY8zci6A4OnqV9T3yVuwXBPuSRcfUduSVDx8Z5+5l93ubYx25D4=',
# 'x-amz-request-id': '484102AF1699E9FA', 'date': 'Fri, 01 Feb 2019 09:05:35 GMT', 
#'transfer-encoding': 'chunked', 'server': 'AmazonS3'}, 'RetryAttempts': 0},
# 'Payload': <botocore.eventstream.EventStream object at 0x7fa0537ccac8>}

for x in resp['Payload']:
	if 'Records' in x:
		print (x['Records']['Payload'].decode('utf-8'))
	elif 'Stats' in x:
		print(x['Stats'])




##for reading parquet
#
#query = boto3.client('s3')
#
#resp = query.select_object_content(
#	Bucket='raynpete-athenadata',
#	Key='parquet/test1.parquet',
#	Expression=" Select * from s3object ",
#	ExpressionType='SQL',
#	InputSerialization={
#	"Parquet":{},},
#	OutputSerialization={'JSON':{}},
#	)
#
