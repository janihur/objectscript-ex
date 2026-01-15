Class OSEX.IOP.Production.ExtraProperties Extends Ens.Production
{

Property Bar As %String;

Property Foo As %String [ InitialExpression = "From class definition" ];

Parameter SETTINGS = "Bar,Foo";

XData ProductionDefinition
{
<Production Name="OSEX.IOP.Production.ExtraProperties" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description>A dummy production to demonstrate extra properties.</Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Setting Target="Production" Name="Bar">From production definition</Setting>
</Production>
}

}
