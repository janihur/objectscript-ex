Include OSEX

/// XSLT2 examples.
Class OSEX.XSLT2 Extends %RegisteredObject
{

/// Read data from XData and run transformation.
ClassMethod Ex1(displayResult As %Boolean = {$$$FALSE})
{
	#dim status as %Status = $$$OK
	#dim ex as %Exception.AbstractException
	
	try {
		// --------------------------------------------------------------------
		// 1) get the XML to be transformed
		// set inputXML = ##class(%Dictionary.CompiledXData).%OpenId($classname()_"||ExampleXML").Data
		#dim inputXML as %Stream.TmpCharacter
		set inputXML = ..readXData("Ex1XML")
		// zwrite inputXML
		if ('$IsObject(inputXML)) {
			set status = %objlasterror
			quit
		}
		// --------------------------------------------------------------------
		// 2) get the transformation stylesheet
		// set stylesheet = ##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example1XSL").Data
		#dim stylesheet as %Stream.TmpCharacter
		set stylesheet = ..readXData("Ex1XSLT")
		// zwrite stylesheet
		if ('$IsObject(stylesheet)) {
			set status = %objlasterror
			quit
		}
		// --------------------------------------------------------------------
		// 3) run transformation: inputXML -> stylesheet -> outputXML
		#dim outputXML as %Stream
		set status = ##class(%XML.XSLT2.Transformer).TransformStream(inputXML,stylesheet,.outputXML)
		if ($$$ISERR(status)) {
			quit
		}
		// --------------------------------------------------------------------
		// 4 optionally show the result
		if (displayResult){
			// zwrite outputXML
			set status = outputXML.OutputToDevice()
		}
	} catch (ex) {
		set status = ex.AsStatus()
	}
	
	if ($$$ISERR(status)) {
		// zwrite status
		do $system.Status.DisplayError(status)
	}
}

/// Read data from files and run transformation.
/// path needs to be absolute.
ClassMethod Ex2(path As %String)
{
	#dim status as %Status = $$$OK
	#dim ex as %Exception.AbstractException
	
	try {
		// --------------------------------------------------------------------
		// 1) read input XML from a file
		set inputXML = ##class(%Stream.FileBinary).%New()
		set status = inputXML.LinkToFile(path_"/ex2.xml")
		if ($$$ISERR(status)) {
			quit
		}
		// --------------------------------------------------------------------
		// 2) read stylesheet from a file
		set stylesheet = ##class(%Stream.FileBinary).%New()
		set status = stylesheet.LinkToFile(path_"/ex2.xsl")
		if ($$$ISERR(status)) {
			quit
		}
		// --------------------------------------------------------------------
		// 3) run transformation: inputXML -> stylesheet -> outputXML
		#dim outputXML as %Stream
		set status = ##class(%XML.XSLT2.Transformer).TransformStream(inputXML,stylesheet,.outputXML)
		if ($$$ISERR(status)) {
			quit
		}
		// --------------------------------------------------------------------
		// 4) save output stream to a file
		set outputFile = ##class(%File).%New(path_"/ex2-output.xml")
		set status = outputFile.Open("WRN")
		if ($$$ISERR(status)) {
			quit
		}
		
		while ('outputXML.AtEnd) {
			set status = outputFile.Write(outputXML.ReadLine())
			if ($$$ISERR(status)) {
				quit
			}
		}
		
		do outputFile.Close()
	} catch (ex) {
		set status = ex.AsStatus()
	}
	
	if ($$$ISERR(status)) {
		// zwrite status
		do $system.Status.DisplayError(status)
	}
}

ClassMethod readXData(xDataName As %String) As %Stream.TmpCharacter [ Private ]
{
	return ##class(%Dictionary.CompiledXData).%OpenId($classname()_"||"_xDataName).Data
}

XData Ex1XML
{
<?xml version="1.0" encoding="UTF-8"?>
<world>
<country name="Canada" continent="North America">
<city>Toronto</city>
<city>Vancouver</city>
</country>
<country name="Jamaica" continent="North America">
<city>Kingston</city>
<city>Ocho Rios</city>
</country>
<country name="United States" continent="North America">
<city>Boston</city>
<city>Baltimore</city>
</country>
<country name="United Kingdom" continent="Europe">
<city>London</city>
<city>Glasgow</city>
</country>
<country name="France" continent="Europe">
<city>Paris</city>
<city>Nice</city>
</country>
<country name="Japan" continent="Asia">
<city>Tokyo</city>
<city>Osaka</city>
</country>
</world>
}

XData Ex1XSLT
{
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  exclude-result-prefixes="fo xs xdt fn" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
<xsl:template match="/">
<xsl:element name="world">
<xsl:for-each-group select="//country" group-by="@continent">
<xsl:sort select="@continent" data-type="text" order="ascending"/>
<xsl:variable name="continent" select="@continent"/>
<xsl:apply-templates select="//country[@continent = $continent]" mode="group">
<xsl:sort select="@name" data-type="text" order="ascending"/>
</xsl:apply-templates>
</xsl:for-each-group>
</xsl:element>
</xsl:template>
<xsl:template match="*" mode="group">
<xsl:copy-of select="."/>
</xsl:template>
</xsl:stylesheet>
}

}

