
<script>
	var covidData = <cfoutput>#serializeJson(args)#</cfoutput>;
	var keyOption = function(key) {
		return key == "global" ? "Global" :
				key == "us" ? "United States" : key;
	};

	var generateHtml = function() {
		var options = [];
		for (var i = 0; i< covidData.sort.length; i++) {
			options.push(`<option value="${covidData.sort[i]}">${keyOption(covidData.sort[i])}</option>`);
		}
		var el = document.createElement("div");
		el.innerHTML = `
			<div style="text-align:center">
				<form class="pure-form pure-form-aligned">
					<fieldset>
						<label for="covid-chart-selector" style="color:white">Select Chart:</label>
						<select id="covid-chart-selector" onChange="loadChart()">
							${options.join(" ")}
						</select>
					</fieldset>
				</form>
			</div>
			<div id="covid-chart"></div>
		`;
		document.getElementById("covid-chart-widget").appendChild(el);
	};

	var loadChart = function() {
		var select = document.getElementById('covid-chart-selector');
		var currentOpt = select.options[select.selectedIndex].value; 
		generateChart(currentOpt);
	};

	var generateChart = function(key) {
		var chartDiv = document.querySelector("#covid-chart");
		var title =
			key == "global" ? "Daily Global COVID-19 Cases" :
			key == "us" ? "Daily COVID-19 Cases in United States" :
			"Daily COVID-19 cases in " + key;

		chartDiv.innerHTML = '';
		var chart = new ApexCharts(chartDiv, {
			title: {
				text: title,
				style: {
					color: '#ffffff'
				}
			},
			series: [{
				name: title,
				data: covidData.dataSets[key].yValues
			}],
			chart: {
				foreColor: '#ffffff',
				height: 350,
				type: 'bar'
			},
			colors: ['#eeeeee'],
			plotOptions: {
				bar: {
					distributed: true
				}
			},
			dataLabels: {
				enabled: false,
				style: {
					colors: ['#ffffff']
				}
			},
			legend: {
				show: false
			},
			xaxis: {
				type: "datetime",
				categories: covidData.dates,
				colors: ['#eeeeee'],
				labels: {
					hideOverlappingLabels: true,
					formatter: function(value, timestamp, index) {
						return moment(new Date(timestamp)).format("MM/DD/YYYY");
					},
					style: {
						fontSize: '12px',
						colors: ['ffffff']
					}
				}
			}
		});
		chart.render();
	};

	document.addEventListener("DOMContentLoaded", function(event) { 				
		generateHtml();
		loadChart();		
	});
</script>