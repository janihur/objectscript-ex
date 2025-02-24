# How to Dump IOP Messaging Objects to File

This is handy for big payloads (megabytes) and slow network connections.

Assumes the actual payloads are character streams like: `Property Data As %Stream.GlobalCharacter`.

Find out the `MessageBodyId` from Management Portal or with SQL like:
```
select * from Ens.MessageHeader 
where SessionId = 2242
;
```

Dump the data to a file. Here it is assumed the message has `Property Data As %Stream.GlobalCharacter`:
```
set b = ##class(Ens.MessageBody).%OpenId(615)
set out = ##class(%Stream.FileCharacter).%New()
zw out.LinkToFile("/home/irisowner/work/dumped.json")
zw out.CopyFrom(b.Data)
```