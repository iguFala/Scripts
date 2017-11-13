from com.bea.wli.sb.management.configuration import SessionManagementMBean
from com.bea.wli.sb.management.configuration import ALSBConfigurationMBean
from com.bea.wli.sb.management.configuration import BusinessServiceConfigurationMBean
from com.bea.wli.sb.util import EnvValueTypes
from com.bea.wli.config import Ref
from com.bea.wli.sb.util import Refs
from xml.dom.minidom import parseString
#!/usr/bin/python
import sys
URL_CONSOLE=sys.argv[1]
#connect(userConfigFile='<userConfigFile_location>', userKeyFile='<userKeyFile_location>', url='t3://<myserver_ip>:<myserver_port>')
#connect(userConfigFile='/u01/home/app/bus11gp4/Config.properties',userKeyFile='/u01/home/app/bus11gp4/Key.properties',url='t3://tungsteno.falabella.cl:11101')
#connect(userConfigFile='/u01/home/app/bus11gp4/Config.properties',userKeyFile='/u01/home/app/bus11gp4/Key.properties',url=URL_CONSOLE)
connect(adminServerName='AdminServer',url=URL_CONSOLE)
domName=cmo.getName()
domainRuntime()
sessionMBean = findService(SessionManagementMBean.NAME,SessionManagementMBean.TYPE)
sessionName="WLSTSession"+ str(System.currentTimeMillis())
sessionMBean.createSession(sessionName)
alsbSession = findService(ALSBConfigurationMBean.NAME + "." + sessionName, ALSBConfigurationMBean.TYPE)
alsbCore = findService(ALSBConfigurationMBean.NAME, ALSBConfigurationMBean.TYPE)
allRefs=alsbCore.getRefs(Ref.DOMAIN)
for ref in allRefs.iterator():
    typeId = ref.getTypeId()
    if typeId == "BusinessService" :
	name=ref.getFullName()
        uris=alsbSession.getEnvValue(ref, EnvValueTypes.SERVICE_URI_TABLE, None)
	print name
	print '#'
	print uris
	print "	"  
exit()

