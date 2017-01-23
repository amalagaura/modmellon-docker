## Dockerfile for Mellon authentication with proxy passthrough

#### To get this working on a Mac you have to make a separate arrangement for networking.
Docker on Mac OSX does not have a bridge network, we will create a separate IP and your proxied application must be listening on 0.0.0.0, not just localhost.

https://docs.docker.com/docker-for-mac/networking/#/use-cases-and-workarounds

So create an IP alias as they suggest or just ensure you have an address that is reachable from a docker container (such as a service running on another docker container)

```sudo ifconfig lo0 alias 10.200.10.1/24```

We will use this IP when starting the docker container so it knows where to proxy requests to. Needs a trailing slash.

#### IDP which you can configure with a new connector
##### Onelogin offers free test apps which work as an IDP. Need to follow these [instructions](https://support.onelogin.com/hc/en-us/articles/202673944-How-to-Use-the-OneLogin-SAML-Test-Connector):

We will use the first basic **SAML Test Connector**.

Set:
* Audience 
* Recipient
* ACS URL Validator
* ACS (Consumer) URL

According to the included screenshot

Download the metadata file from OneLogin (under More Actions), it will be used when starting the docker container

##### Private Key for the Mellon SP
Create a throwaway private key as follows into the file `private.key`

``openssl req -nodes -newkey rsa:2048 -keyout private.key -subj "/C=US/ST=Somewhere/L=Somewhere/O=Organization/OU=IT Department/CN=localhost"``

We will ignore the CSR as Docs say it is optional

Finally plug it all in:

```docker run --rm -p 80:80 --name mellon -v /path/to/private.key:/etc/apache2/mellon/sp_private.key -v /path/to/idp_metadata.xml:/etc/apache2/mellon/idp_metadata.xml -e PROXY_URL=http://10.200.10.1:3000/ mellon```