# Dynu DDNS Update Client
### An extremely minimal (<10MB) image with cURL and Alpine Linux running a Bash script to update Dynu DDNS entries

## Usage:
### Terminal:
```bash
docker run -d -e USERNAME=<your-dynu-username> -e PASSWORD=<your-dynu-password> -e DOMAIN=<your-domain> -e DELAY=<delay-in-seconds*> --restart=unless-stopped cobaltdocker/dynu-updater
```
### Docker Compose
```yml
...
ddns:
	image: cobaltdocker/dynu-updater
	environment:
		USERNAME: "<your-dynu-username>"
		PASSWORD: "<your-dynu-password>"
		DOMAIN: "<your-domain>"
		DELAY: "<delay-in-seconds*>"
	container_name: ddns
    restart: unless-stopped
...
```
<sup>*Omit the delay environment variable to default to 15 seconds</sup>

### CAVEATS
* To update multiple domains, you will need to run separate containers, just change out the $DOMAIN variable for each one.

## Default Environment Variables
DELAY: 15 (seconds)
