[joelj@amazonlinux docker]$ docker build .
Sending build context to Docker daemon  2.048kB
Step 1/3 : FROM alpine
latest: Pulling from library/alpine
c9b1b535fdd9: Pull complete
Digest: sha256:ab00606a42621fb68f2ed6ad3c88be54397f981a7b70a79db3d1172b11c4367d
Status: Downloaded newer image for alpine:latest
 ---> e7d92cdc71fe
Step 2/3 : RUN apk add --update redis
 ---> Running in ab858ea3beb4
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
(1/1) Installing redis (5.0.7-r0)
Executing redis-5.0.7-r0.pre-install
Executing redis-5.0.7-r0.post-install
Executing busybox-1.31.1-r9.trigger
OK: 7 MiB in 15 packages
Removing intermediate container ab858ea3beb4
 ---> d30b4fd48546
Step 3/3 : CMD ["redis-server"]
 ---> Running in 7ac99fd3e879
Removing intermediate container 7ac99fd3e879
 ---> 747ed20cf60e
Successfully built 747ed20cf60e


[joelj@amazonlinux docker]$ docker build .
Sending build context to Docker daemon  2.048kB
Step 1/3 : FROM alpine
 ---> e7d92cdc71fe
Step 2/3 : RUN apk add --update redis
 ---> Using cache
 ---> d30b4fd48546
Step 3/3 : CMD ["redis-server"]
 ---> Using cache
 ---> 747ed20cf60e
Successfully built 747ed20cf60e
[joelj@amazonlinux docker]$




#=========================================
#Commands to be executed at home 
#=========================================

Example 1 
Adding another dependency 

#Use an Existing Docker Images as a Base
FROM alpine

#Download and Install a dependency
RUN apk add --update redis
RUN apk add --update gcc

#Tell the Image what to do when it starts as a container
CMD ["redis-server"]

#=========================================
Unable to understand , needs a revisit
docker Tag 


#=========================================
Goal : Create a tiny nodejs web app & wrap it inside the docker container and be able to access the web application from browser running on the local machine 


1. Make the nodejs run inside the docker container 



Table 
1. Create a NodeJS web app 
2. Create a Docker File 
3. Building Image from dockerfile 
4. Run image as container 
5. Connect to the web app from a browser 
#=========================================

creating a project of node.js

package.json
	{
		"dependencies" :
			{"express":"*"},
		"scripts" :
			{"start": "node index.js"}
		
	}
	
	


index.js
	
const express = require('express');
const app = express ();
app.get('/', (req, res) => {
	res.send('Hello there');
	});

app.listen(8092,() => {
console.log('reading on port 8092');

});

Dockerfile
FROM node:alpine
COPY ./ ./
WORKDIR /proj/app/
RUN npm install
CMD ["npm","start"]

docker run -p 8092:8092 njohnjoel/nodejs
docker run -p 5000:8092 njohnjoel/nodejs
#=========================================

Creating a Simple web application that simply display the number of visits 

Here we need 2 seperate components 
Node App & Redis Server 

Redis is an in-Memory DataStore 
a very tiny database that sits inside the memory for quicker actions 
The Only purpose of the redis server to show us how many times the webpage has been visited 

well we can use Node App to show us the number of visits , Just to complicate things we wanted to add another app


package.json
	{
		"dependencies" :
			{"express":"*",
			 "redis":"2.8.0"
			},
		"scripts" :
			{
			"start": "node index.js"
			}
		
	}
	
	
index.js

	const express = require('express');
	const redis = require('redis')
	
	const app = express ();
	
	const client = redis.createClient();
	client.set('visits', 0);
	
	app.get('/', (req, res) => {
		client.get('visits',(err,visits) =>
		{
			res.send('Number of visits is ' + visits);
			client.set('visits',parseInt(visits) + 1);
		})
	});

app.listen(8092,() => {
console.log('reading on port 8092');

});



Dockerfile
FROM node:alpine
WORKDIR /proj/app/
COPY package.json
RUN npm install
COPY . .
CMD ["npm","start"]


#=========================================================
#Installing Docker Compose 
## Ref : https://docs.docker.com/compose/install/
#==============

sudo yum install curl
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

#=========================================================