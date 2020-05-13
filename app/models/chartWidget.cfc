/**
 * This component is responsible for taking processing the csvLib data that's uploaded into the repo into
 * more usable csv files for daily numbers.
 */
component singleton {

	property name="renderer" inject="provider:coldbox:renderer";
	property name="csvLib" inject="csvLib";
	property name="jsonEditor" inject="jsonEditor";

	property name="dataTransformDestination" inject="coldbox:setting:dataTransformDestination";
	property name="s3Config" inject="coldbox:setting:s3";


	public void function buildDailyChart() {
		var fileText = fileRead(dataTransformDestination.dailyCases);
		var rawData = csvLib.csvToArrayOfStructs(fileText);
		var setKeys = getChartColumns(rawData[1].keyArray());
		var dataSets = {};
		var dataSetOrder = [];
		var dates = [];

		for (var key in setKeys) {

			var chartTitle =
				key == "global" ? "Daily Global COVID-19 Cases" :
				key == "us" ? "Daily COVID-19 Cases in United States" :
				"Daily COVID-19 cases in #key#";

			dataSets[key] = {
				'yValues': []
			};

			for (var record in rawData) {
				if(datediff('d','2020-03-01',record.date) gte 0) {
					dataSets[key].yValues.append(record[key] > 0 ? record[key] : 0);
					if (key == 'global') {
						dates.append(record.date);
					}
				}
			}
			dataSetOrder.append(key);
		}

		var covidData = {
			'dataSets': dataSets,
			'sort': dataSetOrder,
			'dates': dates
		};

		local.generatedJavascript = renderer.renderView("siteBuilder/dailyChartBuilder", covidData);

		var widgetFileName = "covidDailyWidget#dateTimeFormat(now(),"yyyymmddhhnn")#.js";

		jsonEditor.updateProperty(s3Config.tracker, "dailyWidget", widgetFileName);
		generateS3Asset(minifyJs(local.generatedJavascript), widgetFileName);
	}

	public string function getDailyPreviewJs() {
		var file = jsonEditor.getProperty(s3Config.tracker, "dailyWidget");
		return fileRead("#s3Config.path#\#file#");
	}

	private void function buildWidget() {

	}

	private array function getChartColumns(required array originalColumns) {
		var sortedColumns = duplicate(originalColumns);
		var excludedColumns = ["us", "global", "date", "Diamond Princess", "Grand Princess", "American Samoa"];
		return sortedColumns
			.filter(function(item) {
				return !arrayFindNoCase(excludedColumns, item);
			})
			.sort(function(item1, item2) {
				return compareNocase(item1, item2)
			})
			.prepend("us")
			.prepend("global");
	}

	public void function generateS3Asset(required string fileContents, required string fileName) {
		fileWrite("#s3Config.path#\#arguments.filename#", fileContents);
	}

	private string function minifyJs(required string jsFileContent) {
		var miniJs = jsFileContent;

		miniJs = replace(miniJs,chr(13)," ","ALL");
		miniJs = replace(miniJs,chr(10)," ","ALL");
		miniJs = replace(miniJs,chr(9)," ","ALL");
		miniJs = replace(miniJs,chr(11)," ","ALL");
		miniJs = replace(miniJs,"  ","","ALL");
		miniJs = replace(miniJs, "<script>","");
		miniJs = replace(miniJs, "</script>","");
		return miniJs;
	}

}