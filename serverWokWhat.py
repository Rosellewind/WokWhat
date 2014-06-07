#Roselle Milvich
#based on raywenderlich.com/3932 tutorial
#How To Create A Socket Based iPhone App and Server
#python serverWokWhat.py       to run from terminal
#telnet localhost 8080 or telnet ipAddress 8080 if on network    tests server
#ps aux |grep server    to find zombie process with "server"
#sudo kill -9 4633      to kill process 4633

from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

unqKey = "6to$3"		#make static
dicOfUsers = {}
dicLoggedIn = {}

class WokWhatServer(Protocol):
	def __init__(self):
		self.username = ""
		self.password = ""

	def connectionMade(self):
		self.factory.clients.append(self)
		print "clients are ", self.factory.clients
        
	def connectionLost(self, reason):
		self.factory.clients.remove(self)
        
	def dataReceived(self, data):
		print "data:"
		print data
		a = data.split('/',10)
		
		
		
		print "a:"
		print a
		log = ""
		msgBack = ""
		if len(a)>4 and a[0] == unqKey:
			command = a[1]
			name = a[2]
			if a[3] == "password":
				password = a[4]
				if command == "newUser":
					if name in dicOfUsers:
						log = "username already taken"
						msgBack = unqKey + "/fail/newUser/"
					else:
						dicOfUsers[name] = password
						dicLoggedIn[name] = password
						log = name + " saved and logged in"
						msgBack = unqKey + "/success/newUser/"
						self.username = name
						self.password = password
				elif command == "login":
					if name in dicOfUsers:
						p = dicOfUsers[name]
						if  len(p) > 0 and p == password:
							dicLoggedIn[name] = password
							log = name + " logged in"	###
							msgBack = unqKey + "/success/login/"
							self.username = name
							self.password = password
					else:
						log = name + " login failed"	###
						msgBack = unqKey + "/fail/login/"
				elif command == "from":
					if name in dicLoggedIn:
						p = dicLoggedIn[name]
						if len(p)>0 and p == password and a[6] in dicLoggedIn and a[5] == "sendTo" and a[7] == "message" and a[9] == "data":
							sendTo = a[6]
							message = a[8]
							data = a[10]
							msg = unqKey + "/from/" + name + "/message/" + message + "/data/" + data
							print "......"
							for c in self.factory.clients:
								print c.username
								if c.username == sendTo:
									print "going to send to: %s" % (c,)
									c.message(msg)
									print "going to send to: %s" % (c,)
						else:
							msgBack = unqKey + "/fail/from/" + name
					else:
						msgBack = unqKey + "/fail/from/?"
		
		
		print log
		self.message(msgBack)			

	def message(self, message):
		print "going to write"
		self.transport.write(message)
#		self.transport.write(message + '\n')
		print "did write"
		print message
        
        

factory = Factory()
factory.protocol = WokWhatServer
factory.clients = []
reactor.listenTCP(8080, factory)
print "WokWhat server started"
reactor.run()
