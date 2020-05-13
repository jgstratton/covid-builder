component singleton{

	public array function csvToArrayOfStructs(required string csvData) {
		var LineDelimiter = chr(10);
		var resultsArray = [];
		var columnArray = [];

		//standardize line breaks
		arguments.csvData = arguments.csvData.ReplaceAll("\r?\n", LineDelimiter);
		var count = 1;
		for (var line in listToArray(arguments.csvData, lineDelimiter)) {
			var lineArray = csvToArray_processLine(line);
			if(count == 1) {
				columnArray = lineArray;
			} else {
				var record = {};
				for (var i = 1; i <= lineArray.len(); i++) {
					record[columnArray[i]] = lineArray[i];
				}
				resultsArray.append(record);
			}
			count++;
		}
		return resultsArray;
	}

	public array function csvTo2Darray(required string csvData) {
		var LineDelimiter = chr(10);
		var resultsArray = [];

		//standardize line breaks
		arguments.csvData = arguments.csvData.ReplaceAll("\r?\n", LineDelimiter);
		for (var line in listToArray(arguments.csvData, lineDelimiter)) {
			var lineArray = csvToArray_processLine(line);
			resultsArray.append(lineArray);
		}
		return resultsArray;
	}

	private array function csvToArray_processLine(required string line) {
		var lineArray = [];
		var inQualifiedWord = false;
		var qualifiedWord = "";
		var wordArray = listToArray(arguments.line, ",", true);

		for (var word in wordArray) {
			word = trim(word);
			if (!inQualifiedWord) {
				if (left(word,1) == '"') {
					if (right(word,1) == '"') {
						lineArray.append(removeLeadingAndTrailingCharacters(word));
					} else {
						inQualifiedWord = true;
						qualifiedWord = word;
					}
				} else {
					lineArray.append(word);
				}
			} else {
				qualifiedWord &= "," & word;
				if (right(word,1) == '"') {
					inQualifiedWord = false;
					lineArray.append(removeLeadingAndTrailingCharacters(qualifiedWord));
				}
			}
		}
		return lineArray;
	}

	private string function removeLeadingAndTrailingCharacters(required string value) {
		return mid(value, 2, len(value)-2);
	}

	public string function arrayToCSV(required string fileName, required array arrayValues) {
		fileWrite(fileName, "");
		for (var line in arrayValues){
			for (var valueIndex = 1; valueIndex <= line.len(); valueIndex++) {
				if (find(",", line[valueIndex])) {
					line[valueIndex] = '"#line[valueIndex]#"';
				}
			}
			fileAppend(filename, arrayToList(line) & Chr(13) & Chr(10));
		}
	}
}