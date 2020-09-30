Red Hat Process Automation Manager 7 Install Demo
=================================================

This project is a fork from https://github.com/jbossdemocentral/rhpam7-install-demo
It was been customizzed for a specific use-case.

### Start Demo

#### Requirements

You have to install on your workstation the following software:

 - vagrant
 - virtualbox

Also, you have to create and add in `.installs` folder the JBOSS application packages:

 * Red Hat Enterprise Application Platform archive (jboss-eap-7.2.0.zip) at https://developers.redhat.com/products/eap/download
 * Red Hat Process Automation Manager deployable (rhpam-7.7.0-business-central-eap7-deployable.zip) at https://developers.redhat.com/products/rhpam/download
 * Red Hat Process Automation Manager Process Server (KIE Server) deployable (rhpam-7.7.0-kie-server-ee8.zip) at https://developers.redhat.com/products/rhpam/download
 * Red Hat Process Automation Manager add ons (rhpam-7.7.0-add-ons.zip) at https://developers.redhat.com/products/rhpam/download

#### Run

Enter in the folder project and launch

```
vagrant up
```

When vagrant provision ends, you can check installation here: http://192.168.42.42:8857

#### Notes

Feel free to change settings for your use-cases.

 - If you launch this demo without `vagrant`, check [init.sh](./init.sh) file and edit the variables (see CHANGE THESE comment)
 - You can check and edit credentials in [init.sh](./init.sh)
 - Make sure you have stated the same PATHS of the `init.sh` in [jboss-service.sh](./.support/jboss-service.sh)
