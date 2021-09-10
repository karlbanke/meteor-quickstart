import os
import boto3

ssm_client = boto3.client('ssm')

def getEnvironmentParameters():
    mongodbUriParameter = '/config/'+os.environ['SERVICE_NAME']+'_'+os.environ['APPLICATION_ENV']+'/mongodbUri'
    userAdminRootUrlParameter = '/config/'+os.environ['SERVICE_NAME']+'_'+os.environ['APPLICATION_ENV']+'/userAdminRootUrl'
    userExpiredQueueUrlParameter = '/config/'+os.environ['SERVICE_NAME']+'_'+os.environ['APPLICATION_ENV']+'/userExpiredQueueUrl'
    result = get_parameters([mongodbUriParameter,userAdminRootUrlParameter,userExpiredQueueUrlParameter])
    mongodbUri=""
    userAdminRootUrl=""
    userExpiredQueueUrl=""
    for p in result["Parameters"]:
        if p["Name"] == mongodbUriParameter:
            mongodbUri = p["Value"]
        if p["Name"] == userAdminRootUrlParameter:
            userAdminRootUrl = p["Value"]
        if p["Name"] == userExpiredQueueUrlParameter:
            userExpiredQueueUrl = p["Value"]

    keyValue={"mongodbUri": mongodbUri, "userAdminRootUrl":userAdminRootUrl, "userExpiredQueueUrl": userExpiredQueueUrl}
    print(keyValue)
    return keyValue

def get_parameters(parameter_names):
    """Get multiple parameter details in AWS SSM
    :param parameter_names: List of parameter names to fetch details from AWS SSM
    :return: Return parameter details if exist else None
    """
    try:
        result = ssm_client.get_parameters(Names=parameter_names)
    except e:
        print('ERROR: Get parameters from AWS Parameter: %s' % e)
        return []
    return result

def main():
    os.environ['SERVICE_NAME'] = "audio-hub-user-administration"
    os.environ['APPLICATION_ENV'] = "devel"
    getEnvironmentParameters()


if __name__ == '__main__':
    main()