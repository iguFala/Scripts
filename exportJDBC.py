#!/usr/bin/python
import sys
URL_CONSOLE=sys.argv[1]
def enableCredentialAccess(domainName):
	edit()
	startEdit()
	cd('/SecurityConfiguration/' + domainName + '/')
	cmo.setClearTextCredentialAccessEnabled(true)
	save()
	activate()

def disableCredentialAccess(domainName):
	edit()
	startEdit()
	cd('/SecurityConfiguration/' + domainName + '/')
	cmo.setClearTextCredentialAccessEnabled(false)
	save()
	activate()

connect(adminServerName='AdminServer',url=URL_CONSOLE)
allJDBCResources = cmo.getJDBCSystemResources()
domName = cmo.getName()
enableCredentialAccess(domName)
for jdbcResource in allJDBCResources:
	dsName = jdbcResource.getName()
	dsResource = jdbcResource.getJDBCResource()
	user = ''
	passwd = ''
	type = 'Generic'
	try:
		user = get("/JDBCSystemResources/"+ dsName +"/Resource/" + dsName + "/JDBCDriverParams/" + dsName + "/Properties/" + dsName + "/Properties/user/Value")
		passwd = get("/JDBCSystemResources/" + dsName + "/JDBCResource/" + dsName + "/JDBCDriverParams/" + dsName + "/Password")
	except WLSTException:
		pass
		type = 'Multi'
	stopRedirect()
	print dsName,";",dsResource.getJDBCDataSourceParams().getJNDINames()[0],";",dsResource.getJDBCDriverParams().getUrl(),";",user,";",passwd,";",type
disableCredentialAccess(domName)
disconnect()
exit()
