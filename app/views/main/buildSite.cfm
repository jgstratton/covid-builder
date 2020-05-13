<cfset chartWidget = application.wirebox.getInstance("chartWidget")>
<cfset siteBuilder = application.wirebox.getInstance("siteBuilder")>
<ul>
	<li>Building Daily Chart...</li>
	<cfset chartWidget.buildDailyChart()> 
	<li>Building site...</li>
	<cfset siteBuilder.build()>
	<li>Done.</li>
</ul>
