---
layout: projects 
title: SSH into a docker container running on google cloud 
mathjax: true
---

I'm looking to ssh into a docker container running on google's managed kubernetes service. This requires gcloud to be running on the machine.

Steps:

1. List instances `gcloud compute instances list` which will return the list of instances. Pick one.
1. SSH into the instance using the command: `gcloud compute ssh <instance_name> --zone=<instance_zone>`
1. That broke broke I needed an additional role to be get a service account:
```
ERROR: (gcloud.compute.ssh) Could not add SSH key to instance metadata:
 - The user does not have access to service account '951529211349-compute@developer.gserviceaccount.com'.  User: 'XXXXX@XXXX'.  Ask a project owner to grant you the iam.serviceAccountUser role on the service account

```
1. Soo, I then opened up the cloud console (via the webpage) and typed in the same `gcloud compute ssh...` command above. This time when it created a set of keys it worked. 
1. I then copied the keys to my local box.
1. Then the `gcloud compute ssh` worked.




