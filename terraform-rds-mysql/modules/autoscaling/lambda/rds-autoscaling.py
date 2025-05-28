import boto3
import os
from botocore.config import Config
import logging

# Configure logger for logging to both CloudWatch Logs and terminal

logger = logging.getLogger()
logger.setLevel(logging.INFO)


# Create a handler for logging to terminal
# terminal_handler = logging.StreamHandler()
# terminal_handler.setLevel(logging.INFO)
# formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
# terminal_handler.setFormatter(formatter)
# logger.addHandler(terminal_handler)


# AWS SDK configuration
my_config = Config(
    region_name = os.environ['aws_region_name']
)


# Initialize RDS client
rds_client = boto3.client('rds', config=my_config)


# Main handler function
def lambda_handler(event,context):

    # Get environment variables for scaling operations
    down_instance_class = os.environ['down_instance_class']
    instance_identifier = os.environ['instance_identifier']
    up_instance_class   = os.environ['up_instance_class']
    
    # Log the event received
    logger.info(f"Event fired: {event}")

    # Perform scaling based on event details
    if (event["resource"] == "rds" and event["activity"] == "scale down"):
        scaleDownDBInstance(instance_identifier,down_instance_class)
    if (event["resource"] == "rds" and event["activity"] == "scale up"):
        scaleUpDBInstance(instance_identifier,up_instance_class)
        



def scaleDownDBInstance(DBInstanceIdentifier,DBInstanceClass):
    
    try:
        # Modify the RDS instance to scale down
        response = rds_client.modify_db_instance(
            DBInstanceIdentifier=DBInstanceIdentifier,
            DBInstanceClass=DBInstanceClass,
            ApplyImmediately=True
            )
        logger.info(f"Scaling down RDS instance {DBInstanceIdentifier}...")
        logger.info("Response: %s", response)
    except Exception as e:
        logger.error("Error scaling down RDS instance: %s", str(e))
        
        
def scaleUpDBInstance(DBInstanceIdentifier,DBInstanceClass):
    
    try:
        # Modify the RDS instance to scale up
        response = rds_client.modify_db_instance(
            DBInstanceIdentifier=DBInstanceIdentifier,
            DBInstanceClass=DBInstanceClass,
            ApplyImmediately=True
            )
        logger.info(f"Scaling up RDS instance {DBInstanceIdentifier}...")
        logger.info("Response: %s", response)
    except Exception as e:
        logger.error("Error scaling up RDS instance: %s", str(e))
    

# import boto3
# import os

# def lambda_handler(event, context):
#     rds = boto3.client('rds')
    
#     replica_id = os.environ['REPLICA_ID']
#     business_class = os.environ['BUSINESS_HOURS_CLASS']
#     off_hours_class = os.environ['OFF_HOURS_CLASS']
    
#     try:
#         if event.get('action') == 'scale_up':
#             response = rds.modify_db_instance(
#                 DBInstanceIdentifier=replica_id,
#                 DBInstanceClass=business_class,
#                 ApplyImmediately=True
#             )
#             print(f"Scaled up to {business_class}: {response}")
            
#         elif event.get('action') == 'scale_down':
#             response = rds.modify_db_instance(
#                 DBInstanceIdentifier=replica_id,
#                 DBInstanceClass=off_hours_class,
#                 ApplyImmediately=True
#             )
#             print(f"Scaled down to {off_hours_class}: {response}")
            
#         return {
#             'statusCode': 200,
#             'body': 'Scaling operation successful'
#         }
        
#     except Exception as e:
#         print(f"Error: {str(e)}")
#         raise e