# Joplin S3 Sync Configuration

## What is this?

This repo contains a script `create-bucket.sh` for the creation of the necessary AWS resources for allowing Joplin to sync with S3. In order to sync with S3, Joplin asks for a bucket name, S3 URL, region, access key and secret key.

The script creates a bucket, policy and a user. It then attaches the policy to the user and creates an access key for the user.

The repo also contains a script for removing these resources if needed.

## How to Use

There are two scripts. Both scripts take in the name of the bucket.

```shell
# Create a bucket called bucket-name with necessary resources for access
./create-bucket.sh bucket-name

# Remove bucket and resources for access
./remove-bucket.sh bucket-name
```

## Why Joplin 

Joplin is an open-source note-taking and to-do application designed to handle a large number of notes organized into notebooks. One of its standout features is end-to-end encryption,        
ensuring that your notes remain private, secure, and accessible across multiple devices.                                                                                                      

It offers Markdown support, catering to both developers and non-technical users alike. The application supports attachments, enabling    
users to enrich their notes with various forms of media. Furthermore, Joplin's robust synchronization feature stands out, as it supports popular cloud services like Dropbox, OneDrive, and   
Nextcloud.                                                                                                                                                                                    

The ability to sync with Amazon S3 adds another dimension of flexibility and control, allowing users to leverage AWS's durability and reliability for their notes storage. This makes Joplin  
an excellent choice for those seeking a versatile and secure note-taking solution that they can tailor to their specific needs, including integration with custom scripts and cloud services.

