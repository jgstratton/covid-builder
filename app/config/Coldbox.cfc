  
component{

	// Configure ColdBox Application
	function configure(){
		coldbox = {
			appName   = "Covid Stats Static Site Generator",
			reinitPassword = "1",
			handlersIndexAutoReload = true,
			customErrorTemplate  = "/coldbox/system/includes/BugReport.cfm",
			caseSensitiveImplicitViews = true,
			coldbox.implicitViews = false
		};

		var sourceDataPath = getEnv('source_data');
		var s3GeneratedPath = getEnv('s3_generated');
		var generatedDataPath = getEnv('generated_data');

		var rootPath = replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","ALL");
		var rootPath = replace(rootPath,"/app/config/","");
		
		var timeSeriesPath = sourceDataPath & "/csse_covid_19_data/csse_covid_19_time_series";

		settings = {
			s3: {
				path: s3GeneratedPath,
				tracker: s3GeneratedPath & "/tracker.json",
				logo: getEnv('logo')
			},

			dataTransformSource:{
				confirmedGlobal: timeSeriesPath & "/time_series_covid19_confirmed_global.csv",
				confirmedUS: timeSeriesPath & "/time_series_covid19_confirmed_US.csv",
				deathsGlobal: timeSeriesPath & "/time_series_covid19_deaths_global.csv",
				deathsUS: timeSeriesPath & "/time_series_covid19_deaths_US.csv"
			},

			dataTransformDestination: {
				totalCases: generatedDataPath & "/totalCases.csv",
				totalDeaths: generatedDataPath & "/totalDeaths.csv",
				dailyCases: generatedDataPath & "/dailyCases.csv",
				dailyDeaths: generatedDataPath & "/dailyDeaths.csv"
			}
		}
	}
}