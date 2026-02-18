# Web Gateway with Apache Http Server

Prior to [2023.2](https://docs.intersystems.com/iris20251/csp/docbook/DocBook.UI.Page.cls?KEY=GCRN_new20232) InterSystems IRIS included a built-in web server called Private Web Server (PWS) that was used to host web applications such as Management Portal. Starting with [2023.2](https://docs.intersystems.com/iris20251/csp/docbook/DocBook.UI.Page.cls?KEY=GCRN_new20232) PWS has been removed and you need to install and configure your own web server (referred as _external web server_) to host these applications.

The community editions will continue to include the Web Gateway and preconfigured external web server.

* [Web Gateway Guide](https://docs.intersystems.com/iris20251/csp/docbook/DocBook.UI.Page.cls?KEY=GCGI)
  * [Web Gateway Configuration File (CSP.ini) Parameter Reference](https://docs.intersystems.com/iris20251/csp/docbook/DocBook.UI.Page.cls?KEY=GCGI_cspini)

In practice Web Gateway is Apache Http Server module that acts as a gateway between the external web server and InterSystems IRIS. 

## Web Gateway Docker Image

This is the recommended option. See [Web Access Using the Web Gateway Container](https://docs.intersystems.com/iris20251/csp/docbook/DocBook.UI.Page.cls?KEY=ADOCK#ADOCK_iris_webgateway) and [Web Gateway Examples](https://github.com/intersystems-community/webgateway-examples) for simple Docker Compose setup that is good enough when you run IRIS locally. The example uses Web Gateway Docker image with Apache Http Server.

My modifications to the example `CSP.ini` configuration:
* Remove all SSL configuration.
* Update `[LOCAL].Ip_Address` to match the IRIS container hostname.

Other examples:
* [Apache Web Gateway with Docker](https://community.intersystems.com/node/516661)
* [IRIS Web Gateway Example](https://github.com/caretdev/iris-webgateway-example)

## Manual Installation (Ubuntu)

This is not recommended option.

### Apache

* [Apache for UNIX/LINUX/macOS](https://docs.intersystems.com/iris20251/csp/docbook/DocBook.UI.Page.cls?KEY=GCGI_webserver#GCGI_ux_apache)
* [How to install Apache on IRIS supported operating systems](https://community.intersystems.com/node/558151)
* [Installing Apache Server and HealthShare HealthConnect on Ubuntu Linux](https://community.intersystems.com/node/542636)

Apache module [`mod_so`](https://httpd.apache.org/docs/2.4/mod/mod_so.html) is required to run the Web Gateway.

```
# install
sudo apt update
sudo apt install -y apache2

# start the server
sudo service apache2 start

# show the status of the server
service apache2 status

# show the version
apache2 -v

# list compiled modules
apache2 -l

# check the status of all services
service --status-all
```

### Web Gateway

* [Web Gateway Guide](https://docs.intersystems.com/iris20251/csp/docbook/DocBook.UI.Page.cls?KEY=GCGI)
* [Install a Stand-Alone Web Gateway](https://docs.intersystems.com/iris20251/csp/docbook/DocBook.UI.Page.cls?KEY=GCGI_standalone)

```
# obtain the Web Gateway package from you favorite source
mkdir /tmp/webgw
cd /tmp/webgw
tar xvf WebGateway-2024.2.0.247.0-lnxubuntu2404x64.tar.gz
cd WebGateway-2024.2.0.247.0-lnxubuntu2404x64/install/

$ ./cplatname identify
dockerubuntux64

sudo ./GatewayInstall
```

```
install$ sudo ./GatewayInstall
Starting Web Gateway installation procedure.

Please enter platform name: lnxubuntu2404x64

Please enter destination directory for Web Gateway files </opt/webgateway>:
Do you want to create directory /opt/webgateway <Yes>?
Do you want to configure Web Gateway to connect to your InterSystems IRIS server <Yes>?

Specify the WebServer type. Choose "None" if you want to configure
your WebServer manually.
    1) Apache
    2) None
WebServer type <1>?

Please enter location of Apache configuration file </etc/apache2/apache2.conf>:

Please enter hostname of your InterSystems IRIS server <localhost>:

Please enter superserver port number for your InterSystems IRIS server <1972>:

Please enter InterSystems IRIS configuration name <IRIS>:

How restrictive do you want the initial Security settings to be?
"Minimal" is the most secure, "Locked Down" is the least restrictive.
    1) Minimal
    2) Normal
    3) Locked Down
Initial Security settings <1>?

Installing InterSystems IRIS Web Gateway for Apache:
------------------------------------------------------------------
Apache configuration file: /etc/apache2/apache2.conf
InterSystems IRIS configuration name: IRIS
InterSystems IRIS server address: localhost
InterSystems IRIS server port number: 1972
Web Gateway installation directory: /opt/webgateway
------------------------------------------------------------------

Do you want to continue and perform the installation <Y>:

System has not been booted with systemd as init system (PID 1). Can't operate.
Failed to connect to bus: Host is down
    Updating Apache configuration file ...
    - /etc/apache2/apache2.conf

System has not been booted with systemd as init system (PID 1). Can't operate.
Failed to connect to bus: Host is down

Web Gateway configuration completed!
```

Restart the Apache server to apply the changes:
```
sudo service apache2 restart
```