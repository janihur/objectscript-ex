# db1

ObjectScript console:
```
set o = ##class(OSEX.db1.Foo).%New()
set o.num = 1
set o.str = "A"
zw o
zw o.%Save()
zw o

set o = ##class(OSEX.db1.Foo).%OpenId(1)
```

SQL console (`do $SYSTEM.SQL.Shell()`):
```
select * from OSEX_db1.Foo

? = call OSEX_db1.Foo_Upsert(1,'A')

insert or update OSEX_db1.Foo(num, str) values(1,'A')

update OSEX_db1.Foo set num = num + 1 where str = 'A'

delete from OSEX_db1.Foo where str in ('B', 'C')

insert or update OSEX_db1.Foo(num, str) values(num+1,'B')

drop table OSEX_db1.Foo
```