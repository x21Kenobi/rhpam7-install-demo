#!/usr/bin/env sh

# Install REPAM 7.7.0
# AUTHORS: "Red Hat"
# PRODUCT: "Red Hat Process Automation Manager"
# https://raw.githubusercontent.com/jbossdemocentral/rhpam7-install-demo/master/init.sh

# CHANGE THESE
SRC_DIR=/vagrant/.installs
SUPPORT_DIR=/vagrant/.support

VERSION=7.7.0
JBOSS_USER=jboss
TARGET=/opt/jboss
JBOSS_EAP=jboss-eap-7.2
JBOSS_HOME=$TARGET/$JBOSS_EAP
SERVER_DIR=$JBOSS_HOME/standalone/deployments
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
PAM_BUSINESS_CENTRAL=rhpam-$VERSION-business-central-eap7-deployable.zip
PAM_KIE_SERVER=rhpam-$VERSION-kie-server-ee8.zip
PAM_ADDONS=rhpam-$VERSION-add-ons.zip
PAM_CASE_MGMT=rhpam-7.7.0-case-mgmt-showcase-eap7-deployable.zip
EAP=jboss-eap-7.2.0.zip

mkdir -p $TARGET
# Create user if not exists
id -u $JBOSS_USER &>/dev/null || useradd $JBOSS_USER

# make some checks first before proceeding.
if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	echo Product sources are present...
	echo
else
	echo Need to download $EAP package from http://developers.redhat.com
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

if [ -r $SRC_DIR/$PAM_BUSINESS_CENTRAL ] || [ -L $SRC_DIR/$PAM_BUSINESS_CENTRAL ]; then
	echo Product sources are present...
	echo
else
	echo Need to download $PAM_BUSINESS_CENTRAL zip from http://developers.redhat.com
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

if [ -r $SRC_DIR/$PAM_KIE_SERVER ] || [ -L $SRC_DIR/$PAM_KIE_SERVER ]; then
	echo Product sources are present...
	echo
else
	echo Need to download $PAM_KIE_SERVER zip from http://developers.redhat.com
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

if [ -r $SRC_DIR/$PAM_ADDONS ] || [ -L $SRC_DIR/PAM_ADDONS ]; then
	echo Product sources are present...
	echo
else
	echo Need to download $PAM_ADDONS zip from http://developers.redhat.com
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

# Check JBoss instance, if it exists.
if [ -x $JBOSS_HOME ]; then
	echo " 	Error occurred during JBoss EAP installation! "
	echo "  JBOSS installation already exists "
	echo
	exit
fi

# Run installers.
echo "Provisioning JBoss EAP now..."
echo
unzip -qo $SRC_DIR/$EAP -d $TARGET

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during JBoss EAP installation!
	exit
fi

echo
echo "Deploying Red Hat Process Automation Manager: Business Central now..."
echo
unzip -qo $SRC_DIR/$PAM_BUSINESS_CENTRAL -d $TARGET

if [ $? -ne 0 ]; then
	echo Error occurred during $PRODUCT installation
	exit
fi

echo
echo "Deploying Red Hat Process Automation Manager: Process Server now..."
echo
unzip -qo $SRC_DIR/$PAM_KIE_SERVER -d $SERVER_DIR

if [ $? -ne 0 ]; then
	echo Error occurred during $PRODUCT installation
	exit
fi
touch $SERVER_DIR/kie-server.war.dodeploy

echo
echo "Deploying Red Hat Process Automation Manager: Case Management Showcase now..."
echo

unzip -qo $SRC_DIR/$PAM_ADDONS $PAM_CASE_MGMT -d $TARGET
unzip -qo $TARGET/$PAM_CASE_MGMT -d $TARGET
rm $TARGET/$PAM_CASE_MGMT

if [ $? -ne 0 ]; then
	echo Error occurred during $PRODUCT installation
	exit
fi

# Set deployment Case Management.
touch $JBOSS_HOME/standalone/deployments/rhpam-case-mgmt-showcase.war.dodeploy

echo
echo "  - enabling demo accounts role setup..."
echo

echo "  - setup manager realm user 'admin' with password 'manageME.2020'..."
echo
$JBOSS_HOME/bin/add-user.sh -u admin -p manageME.2020 -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all --silent

echo "  - adding user 'pamAdmin' with password 'redhatpam1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u pamAdmin -p redhatpam1! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all --silent

echo "  - adding user 'adminUser' with password 'test1234!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u adminUser -p test1234! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all --silent

echo "  - adding user 'kieserver' with password 'kieserver1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u kieserver -p kieserver1! -ro kie-server --silent

echo "  - adding user 'caseUser' with password 'redhatpam1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u caseUser -p redhatpam1! -ro user --silent

echo "  - adding user 'caseManager' with password 'redhatpam1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u caseManager -p redhatpam1! -ro user,manager --silent

echo "  - adding user 'caseSupplier' with password 'redhatpam1!'..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u caseSupplier -p redhatpam1! -ro user,supplier --silent

echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone-full.xml $SERVER_CONF/standalone.xml

echo "  - setup email task notification users..."
echo
cp $SUPPORT_DIR/userinfo.properties $SERVER_DIR/business-central.war/WEB-INF/classes/

echo "  - making sure server is executable..."
echo
chown -R $JBOSS_USER:$JBOSS_USER $JBOSS_HOME
chmod u+x $JBOSS_HOME/bin/standalone.sh
cp $SUPPORT_DIR/jboss-service.sh /etc/init.d/jbossas7
chmod 755 /etc/init.d/jbossas7

/etc/init.d/jbossas7 start

echo "=============================================================="
echo "=                                                            ="
echo "=  $PRODUCT $VERSION setup complete. 												 ="
echo "=                                                            ="
echo "=  Start $PRODUCT with:            													 ="
echo "=                                                            ="
echo "=           $SERVER_BIN/standalone.sh        								 ="
echo "=                                                            ="
echo "=  Log in to Red Hat Process Automation Manager to start     ="
echo "=  developing rules projects:                                ="
echo "=                                                            ="
echo "=  http://192.168.42.42:8857/business-central                ="
echo "=  http://192.168.42.42:8857/rhpam-case-mgmt-showcase        ="
echo "=                                                            ="
echo "=    Log in: [ u:pamAdmin / p:redhatpam1! ]                  ="
echo "=                                                            ="
echo "=  Admin Console:                                            ="
echo "=  http://192.168.42.42:10767/console 											 ="
echo "=                                                            ="
echo "=    Log in: [ u:admin / p:manageME.2020 ]	                 ="
echo "=                                                            ="
echo "=  OFFSET PORT IS 777                                        ="
echo "=                                                            ="
echo "=    Others:                                                 ="
echo "=            [ u:kieserver / p:kieserver1! ]                 ="
echo "=            [ u:caseUser / p:redhatpam1! ]                  ="
echo "=            [ u:caseManager / p:redhatpam1! ]               ="
echo "=            [ u:caseSupplier / p:redhatpam1! ]              ="
echo "=                                                            ="
echo "=============================================================="
echo
