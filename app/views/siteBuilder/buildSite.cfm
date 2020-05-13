<!---
	This view is used for generating the static site html.
--->
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Stratnet COVID-19</title>
		<meta name="description" content="Covid-19 data viewer">
		<meta name="author" content="Jesse Stratton">
		<link rel="stylesheet" href="https://unpkg.com/purecss@1.0.1/build/pure-min.css" integrity="sha384-oAOxQR6DkCoMliIh8yFnu25d7Eq/PHS21PClpwjOTeU2jRSq11vu66rf90/cZr47" crossorigin="anonymous">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.0/jquery.min.js"></script>
		<style>
			body {
				background-color: black;
				padding:20px;
			}
			h4, p {
				color: white;
			}
			.site-logo{
				width: 200px;
			}
			.site-logo img{
				width:100%;
			}
		</style>
	</head>
	<body>
		<cfoutput>
			<div class="row">
				<div class="site-logo">
					#args.images.logo#
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<h4>COVID-19 Data.</h4>
					<p>
						The following COVID-19 data is pulled from the <a href="https://github.com/CSSEGISandData/COVID-19">data repository</a> 
						operated by the Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE).
					</p>
				</div>
				<div class="col-md-6">
					<div id="covid-chart-widget"></div>
				</div>
			</div>
			
			<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js" integrity="sha256-4iQZ6BVL4qNKlQ27TExEhBN1HFPvAvAMbFavKKosSWQ=" crossorigin="anonymous"></script>
			#args.javaScript.dailyWidget#
		</cfoutput>
	</body>
</html>
