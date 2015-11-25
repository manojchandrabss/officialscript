root@icinga-vpc:~# cat addhost.sh
hostname=$1
hostaddress=$2
env=$3
role=$4

case "$1" in
--help) clear
        echo "-------------------Help-------------------------"
        echo "This scipt is used to add new hosts for monitoring in icinga"
        echo "This script takes four arguments"
        echo "--------------------------------"
        echo " "
        echo "addhost <hostname> <hostaddress> <environment> <hostrole>"
        echo "                      "
        echo "Environments can be as follows"
        echo "------------------------------"
        echo " "
        echo "                          "
        echo "qa"
        echo "qa1"
        echo "qa-testing"
        echo "common"
        echo "performance"
        echo "alpha"
        echo "                               "
        echo "Roles can be as follows:"
        echo "------------------------"
        echo " "
        echo "                           "
        echo "allinone"
        echo "app"
        echo "base"
        echo "elasticsearch"
        echo "gluster"
        echo "idproxy"
        echo "kms"
        echo "logserver"
        echo "mongo"
        echo "plugin"
        echo "presence"
        echo "rabbitmq"
        echo "redis"
        echo "testlink"
        echo "smtp"
        echo "nginx"
        echo "serviceengine"
        echo "alertrouter"
        echo "integration"
        echo "encryption"
        echo "single-elasticsearch"
        echo "alertrouter-serviceengine"
        echo "singleservice"
        exit 1
        ;;
esac


if [ $# -ne 4 ]
then
clear
echo "This script takes four arguments"
echo "addhost <hostname> <hostaddress> <environment> <hostrole>"
echo "for more help use addhost --help"
exit 1
fi


case "$4" in

singleservice) echo "this is singleservice role"
hostrolepath="/usr/local/icinga/etc/objects/singleservices.cfg"
        groupname="singleserver-group"
        ;;
encryption) echo "this is encryption role"
hostrolepath="/usr/local/icinga/etc/objects/encryption.cfg"
        groupname="encryption-group"
        ;;
single-elasticsearch) echo "this is single-elasticsearch role"
        hostrolepath="/usr/local/icinga/etc/objects/single-elasticsearch.cfg"
        groupname="es-single-group"
        ;;

allinone) echo "this is allinone role"
        hostrolepath="/usr/local/icinga/etc/objects/allinone.cfg"
        groupname="allinone-group"
        ;;

base) echo "this is base-vpc role"
        hostrolepath="/usr/local/icinga/etc/objects/base.cfg"
        groupname="base"
        ;;
gluster) echo "this is gluster role"
        hostrolepath="/usr/local/icinga/etc/objects/gluster.cfg"
        groupname="GLUSTER"
        ;;
idproxy) echo "this is idproxy role"
        hostrolepath="/usr/local/icinga/etc/objects/idproxy.cfg"
        groupname="id-proxy-group"
        ;;
kms) echo "this is kms role"
        hostrolepath="/usr/local/icinga/etc/objects/kms.cfg"
        groupname="kms-group"
        ;;
mongo) echo "this is mongo role"
        hostrolepath="/usr/local/icinga/etc/objects/mongo.cfg"
        groupname="mongo"
        ;;
plugin) echo "this is plugin role"
        hostrolepath="/usr/local/icinga/etc/objects/plugin.cfg"
        groupname=""
        ;;
presence) echo "this is presence role"
        hostrolepath="/usr/local/icinga/etc/objects/presence.cfg"
        groupname="presence-group"
        ;;
rabbitmq) echo "this is rabbitmq role"
        hostrolepath="/usr/local/icinga/etc/objects/rabbitmq.cfg"
        groupname="rabbitmq-group"
        ;;
presence) echo "this is presence role"
        hostrolepath="/usr/local/icinga/etc/objects/presence.cfg"
        groupname="presence-group"
        ;;
redis) echo "this is redis role"
        hostrolepath="/usr/local/icinga/etc/objects/redis.cfg"
        groupname="redis-group"
        ;;
testlink) echo "this is testlink role"
        hostrolepath="/usr/local/icinga/etc/objects/testlink.cfg"
        groupname="testlink-group"
        ;;
elasticsearch) echo "this is elasticsearch role"
        hostrolepath="/usr/local/icinga/etc/objects/elasticsearch.cfg"
        groupname="es-group"
        ;;
logserver) echo "this is logserver role"
        hostrolepath="/usr/local/icinga/etc/objects/logserver.cfg"
        groupname="logserver-group"
        ;;
smtp) echo "this is smtp role "
        hostrolepath="/usr/local/icinga/etc/objects/smtp.cfg"
        groupname="smtp-group"
        ;;
app) echo "this is app role "
        hostrolepath="/usr/local/icinga/etc/objects/apps.cfg"
        groupname="app-group"
        ;;
serviceengine) echo "this is serviceengine role "
        hostrolepath="/usr/local/icinga/etc/objects/serviceengine.cfg"
        groupname="Serviceengine-group"
        ;;
alertrouter) echo "this is alertrouter role "
        hostrolepath="/usr/local/icinga/etc/objects/alertrouter.cfg"
        groupname="alertrouter-group"
        ;;

integration)echo "this is integration role "
        hostrolepath="/usr/local/icinga/etc/objects/integration.cfg"
        groupname="integration-group"
        ;;

nginx) echo "this is nginx role "
        hostrolepath="/usr/local/icinga/etc/objects/nginx.cfg"
        groupname="nginx-group"
        ;;
alertrouter-serviceengine) echo "this is alertrouter-serviceengine role "
        hostrolepath="/usr/local/icinga/etc/objects/alertrouter-serviceengine.cfg"
        groupname="Alertrouter-ServiceEngine-group"
        ;;

*) echo "not a valid role"
        exit 1
        ;;
esac


case "$3" in

common) echo "this is common env"
    hostpath="/usr/local/icinga/etc/objects/env/common-env.cfg"
        ;;
qa) echo "this is qa env"
    hostpath="/usr/local/icinga/etc/objects/env/qa-env.cfg"
        ;;
qa1) echo "this is qa1 env"
        hostpath="/usr/local/icinga/etc/objects/env/qa1-env.cfg"
        ;;
qa-testing) echo "this is qa-testing env"
        hostpath="/usr/local/icinga/etc/objects/env/qa-testing-env.cfg"
        ;;
performance) echo "this is performance env"
        hostpath="/usr/local/icinga/etc/objects/env/performance.cfg"
        ;;
alpha)  echo "this is alpha env"
        hostpath="/usr/local/icinga/etc/objects/env/alpha.cfg"
        ;;
*) echo "not a valid env"
        exit 1
        ;;
esac

echo $hostrolepath
echo $hostpath


if [ "$3" = "performance" ]; then
        echo "                                                      "  >> $hostpath
        echo "define host{" >> $hostpath
        echo "       use                     linux-server,pnp-hst" >> $hostpath
        echo "       host_name               $hostname" >> $hostpath
        echo "       alias                   $hostname" >> $hostpath
        echo "       address                 $hostaddress" >> $hostpath
        echo "       hostgroups              $groupname" >> $hostpath
        echo "       }" >> $hostpath
        sed -i -e "s/members /members $hostname,/" $hostpath
else
        echo "                                                      "  >> $hostpath
        echo "define host{" >> $hostpath
        echo "       use                     linux-server,pnp-hst" >> $hostpath
        echo "       host_name               $hostname" >> $hostpath
        echo "       alias                   $hostname" >> $hostpath
        echo "       address                 $hostaddress" >> $hostpath
        echo "       contact_groups         +$3" >> $hostpath
        echo "       }" >> $hostpath

sed -i -e "s/ members / members $hostname,/" $hostrolepath
sed -i -e "s/members /members $hostname,/" $hostpath

fi

service icinga reload

