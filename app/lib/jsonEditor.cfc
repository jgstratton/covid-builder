component singleton accessors="true" {

	public void function updateProperty(required string file, required string propertyName, required any propertyValue) {
		var fileText = fileRead(arguments.file);
		var propertiesStruct = deserializeJSON(fileText);
		propertiesStruct[propertyName] = arguments.propertyValue;
		fileText = serializeJson(propertiesStruct)
		fileText = formatJson(fileText);
		fileWrite(arguments.file, fileText);
	}

	public any function getProperty(required string file, required string propertyName) {
		var fileText = fileRead(arguments.file);
		var propertiesStruct = deserializeJSON(fileText);
		return propertiesStruct[propertyName]
	}

	//https://cflib.org/udf/formatJSON
	public string function formatJSON(str) {
		var fjson = '';
		var pos = 0;
		var strLen = len(arguments.str);
		var indentStr = chr(9);
		var newLine = chr(10);
		
		for (var i=1; i<=strLen; i++) {
			var char = mid(arguments.str,i,1);
			
			if (char == '}' || char == ']') {
				fjson &= newLine;
				pos = pos - 1;
				
				for (var j=1; j<pos; j++) {
					fjson &= indentStr;
				}
			}
			
			fjson &= char;    
			
			if (char == '{' || char == '[' || char == ',') {
				fjson &= newLine;
				
				if (char == '{' || char == '[') {
					pos = pos + 1;
				}
				
				for (var k=1; k<pos; k++) {
					fjson &= indentStr;
				}
			}
		}
		
		return fjson;
	}
}