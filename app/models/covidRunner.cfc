/**
 * This component is responsible for taking processing the daily data that's uploaded into the repo into
 * more usable csv files for daily numbers.
 */
component accessors="true" singleton{
	property name="csvLib" inject="csvLib";
	property name="sourceFiles" inject="coldbox:setting:dataTransformSource";
	property name="destinationFiles" inject="coldbox:setting:dataTransformDestination";

	public void function generateCsvFiles() {
		generateTotalsCSV(variables.sourceFiles.confirmedUS, variables.sourceFiles.confirmedGlobal, variables.destinationFiles.totalCases);
		generateTotalsCSV(variables.sourceFiles.deathsUs, variables.sourceFiles.deathsGlobal, variables.destinationFiles.totalDeaths);
		generatedailyCSV(variables.destinationFiles.totalCases, variables.destinationFiles.dailyCases);
		generatedailyCSV(variables.destinationFiles.totalDeaths, variables.destinationFiles.dailyDeaths);
	}

	public void function generateTotalsCSV(required string usFileName, required string globalFileName, required string resultsFile) {
		var sourceData = csvLib.csvToArrayOfStructs(fileRead(usFileName));
		var excludeFields = ["code3", "fips","lat","long_","uid","population"];
		var globalResults = generateGlobalStruct(globalFileName);

		var results = {
			us: {}
		};

		for (var record in sourceData) {
			for (var key in record) {
				if(!arrayFindNoCase(excludeFields,key) && isNumeric(record[key])) {
					if(record.country_region == "US") {
						param name="results.us['#key#']" default="0";
						results.us[key] += record[key];
						if (len(record.province_state)) {
							param name="results['#record.PROVINCE_STATE#']['#key#']" default=0;
							results[record.PROVINCE_STATE][key] += record[key];
						}
					}
				}
			}
		}

		var columns = results.keyArray().filter(function(item){
			return item != 'us';
		});

		var columns = columns.sort("text", "asc");
		var columns = columns.prepend("us");

		var dates = results.us.keyArray().sort(function(item1,item2){
			return dateCompare(item1, item2);
		});

		var csvData = [];
		csvData.append( duplicate(columns).prepend("global").prepend("date"));
		for (var date in dates) {
			var csvLine = [date, globalResults[date]];
			for (var column in columns) {
				csvLine.append(results[column][date]);
			}
			csvData.append(csvLine);
		}
		csvLib.arrayToCSV(arguments.resultsFile, csvData);
	}

	private struct function generateGlobalStruct(required string globalFileName) {
		var sourceData = csvLib.csvToArrayOfStructs(fileRead(globalFileName));
		var excludeFields = ["lat","long"];
		var globalResults = {};

		for (var record in sourceData) {
			for (var key in record) {
				if(!arrayFindNoCase(excludeFields, key) && isNumeric(record[key])) {
					param name="globalResults['#key#']" default=0;
					globalResults[key] += record[key];
				}
			}
		}
		
		return globalResults;
	}

	public void function generatedailyCSV(required string sourceFileName, required string destinationFileName) {
		var sourceData = csvLib.csvTo2Darray(fileRead(sourceFileName));
		var resultsData = duplicate(sourceData);
		var columnLength  = sourceData[1].len();

		//row 1 is column headers, row 2 is our base for calculating daily numbers, start on 3
		for (var i=3; i <= sourceData.len(); i++) {
			for (var j=2; j<= columnLength; j++) {
				resultsData[i][j] = sourceData[i][j] - sourceData[i-1][j];
			}
		}

		//delete the 2nd row of the results data, there's no useful data there
		resultsData.deleteAt(2);
		csvLib.arrayToCSV(arguments.destinationFileName, resultsData);
	}

	public array function getdailyResults() {
		var fileText = fileRead(variables.files.dailyCases);
		return csvLib.csvToArrayOfStructs(fileText);
	}

	public array function getChartData() {
		var fileText = fileRead(variables.files.dailyCases);
		var rawData = csvLib.csvToArrayOfStructs(fileText);
		var columns = sortColumns(rawData[1].keyArray());
		return columns;
	}

	private array function getChartColumns(required array originalColumns) {
		var sortedColumns = duplicate(originalColumns);
		var excludedColumns = ["us", "global", "date", "Diamond Princess", "Grand Princess"];
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
		fileWrite(variables.s3Path & fileName, fileContents);
	}

}