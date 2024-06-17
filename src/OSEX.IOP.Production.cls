Class OSEX.IOP.Production Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="OSEX.IOP.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="FileExport.Services.Main" Category="FileExport" ClassName="OSEX.IOP.FileExport.Services.Main" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="FileExport.Processes.Main" Category="FileExport" ClassName="OSEX.IOP.FileExport.Processes.Main" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="FileExport.Operations.Export" Category="FileExport" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/out</Setting>
    <Setting Target="Adapter" Name="Charset">cp1252</Setting>
    <Setting Target="Host" Name="Filename">%f_%Q%!+(_a)</Setting>
  </Item>
  <Item Name="Jokes.Services.Main" Category="Jokes" ClassName="OSEX.IOP.Jokes.Services.Main" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Jokes.Processes.Main" Category="Jokes" ClassName="OSEX.IOP.Jokes.Processes.Main" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Jokes.Operations.ChuckNorris" Category="Jokes" ClassName="OSEX.IOP.Jokes.Operations.ChuckNorris" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPServer">api.chucknorris.io</Setting>
    <Setting Target="Adapter" Name="URL">/jokes/random</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
  </Item>
  <Item Name="Jokes.Operations.Simpsons" Category="Jokes" ClassName="OSEX.IOP.Jokes.Operations.Simpsons" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPServer">thesimpsonsquoteapi.glitch.me</Setting>
    <Setting Target="Adapter" Name="URL">/quotes</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
  </Item>
  <Item Name="Misc.Services.Main" Category="Misc" ClassName="OSEX.IOP.Misc.Services.Main" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Misc.Operations.CustomHttpRequest" Category="Misc" ClassName="OSEX.IOP.Misc.Operations.CustomHttpRequest" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPServer">host.docker.internal</Setting>
    <Setting Target="Adapter" Name="HTTPPort">8080</Setting>
    <Setting Target="Adapter" Name="URL">/customhttprequest</Setting>
  </Item>
  <Item Name="UniversalExports.Services.Main" Category="UniversalExports" ClassName="OSEX.IOP.UniversalExports.Services.Main" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="UniversalExports.Processes.Main" Category="UniversalExports" ClassName="OSEX.IOP.UniversalExports.Processes.Main" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="UniversalExports.Operations.BookExport" Category="UniversalExports" ClassName="OSEX.IOP.UniversalExports.Operations.BookExport" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="RegistryID">Export Service||OSEX.IOP.UniversalExports||1</Setting>
  </Item>
  <Item Name="UniversalExports.Operations.BookImport1" Category="UniversalExports" ClassName="OSEX.IOP.UniversalExports.Operations.BookImport" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="RegistryID">Import Service 1||OSEX.IOP.UniversalExports||1</Setting>
  </Item>
  <Item Name="UniversalExports.Operations.BookImport2" Category="UniversalExports" ClassName="OSEX.IOP.UniversalExports.Operations.BookImport" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="RegistryID">Import Service 2||OSEX.IOP.UniversalExports||1</Setting>
  </Item>
</Production>
}

}
