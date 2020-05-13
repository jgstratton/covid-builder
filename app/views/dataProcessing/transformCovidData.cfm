<cfsetting requesttimeout="60000">
<cfset covidRunner = application.wirebox.getInstance("covidRunner")>
<cfset covidRunner.generateCsvFiles()>
Done.