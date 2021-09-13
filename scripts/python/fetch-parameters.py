import os
import boto3
from botocore.config import Config

def getEnvironmentParameters():
    mongodbUriParameter = '/config/'+os.environ['SERVICE_NAME']+'_'+os.environ['APPLICATION_ENV']+'/mongodbUri'
    userAdminRootUrlParameter = '/config/'+os.environ['SERVICE_NAME']+'_'+os.environ['APPLICATION_ENV']+'/userAdminRootUrl'
    userExpiredQueueUrlParameter = '/config/'+os.environ['SERVICE_NAME']+'_'+os.environ['APPLICATION_ENV']+'/userExpiredQueueUrl'
    result = get_parameters([mongodbUriParameter,userAdminRootUrlParameter,userExpiredQueueUrlParameter])
    mongodbUri=""
    userAdminRootUrl=""
    userExpiredQueueUrl=""
    f= open("env.json","w+")
    f.write("{ \n")
    for p in result["Parameters"]:
        if p["Name"] == mongodbUriParameter:
            mongodbUri = p["Value"]
            f.write("\"MONGO_URL\": \"%s\", \n"%(mongodbUri))
        if p["Name"] == userAdminRootUrlParameter:
            userAdminRootUrl = p["Value"]
            f.write("\"USER_ADMIN_ROOT_URL\": \"%s\", \n"%(userAdminRootUrl))
        if p["Name"] == userExpiredQueueUrlParameter:
            userExpiredQueueUrl = p["Value"]
            f.write("\"USER_EXPIRED_QUEUE_URL\": \"%s\" \n"%(userExpiredQueueUrl))
    f.write("}")
    f.close()
    keyValue={"mongodbUri": mongodbUri, "userAdminRootUrl":userAdminRootUrl, "userExpiredQueueUrl": userExpiredQueueUrl}
    print(keyValue)
    return keyValue

def get_parameters(parameter_names):
    """Get multiple parameter details in AWS SSM
    :param parameter_names: List of parameter names to fetch details from AWS SSM
    :return: Return parameter details if exist else None
    """
    try:
        ssm_config = Config(region_name = 'eu-central-1')
        ssm_client = boto3.client('ssm',config=ssm_config)
        result = ssm_client.get_parameters(Names=parameter_names)
    except e:
        print('ERROR: Get parameters from AWS Parameter: %s' % e)
        return []
    return result

def main():
    os.environ['SERVICE_NAME'] = "audio-hub-user-administration"
    os.environ['APPLICATION_ENV'] = "APPLICATION_ENV"
    os.environ['AWS_ACCESS_KEY_ID'] = "AWS_ACCESS_KEY_ID"
    os.environ['AWS_SECRET_ACCESS_KEY'] = "AWS_SECRET_ACCESS_KEY/keyID"
    getEnvironmentParameters()


if __name__ == '__main__':
    main()