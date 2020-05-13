/**
 * This component is responsible for generating the static site.
 */
component accessors="true" singleton {
	property name="renderer" inject="provider:coldbox:renderer";
	property name="jsonEditor" inject="jsonEditor";
	property name="csvLib" inject="csvLib";
	property name="s3Config" inject="coldbox:setting:s3";
	
	public void function build() {
		local.generatedHtml = renderer.renderView("siteBuilder/buildSite", {
			javaScript: {
				dailyWidget: buildJavaScriptAsset("dailyWidget", false)
			},
			images: {
				logo: buildImgAsset("logo", false)
			}
		});
		var indexFileName = "index#dateTimeFormat(now(),"yyyymmddhhnn")#.html";
		jsonEditor.updateProperty(s3Config.tracker, "index", indexFileName);
		generateS3Asset(local.generatedHtml, indexFileName);
		generateS3Asset(local.generatedHtml, "index.html");
	}

	public void function preview() {
		local.generatedHtml = renderer.renderView("siteBuilder/buildSite", {
			javaScript: {
				dailyWidget: buildJavaScriptAsset("dailyWidget", true),
			},
			images: {
				logo: buildImgAsset("logo", true)
			}
		});
		writeoutput(local.generatedHtml);
	}

	public string function buildJavaScriptAsset(required string assetKey, required boolean preview) {
		var assetSource = jsonEditor.getProperty(s3Config.tracker, assetKey);
		if (preview) {
			local.generatedContent = '<script>#fileRead("#s3Config.path#/#assetSource#")#</script>';
		} else {
			local.generatedContent = '<script src="./#assetSource#"></script>';
		}

		return local.generatedContent;
	}

	public string function buildImgAsset(required string assetKey, required boolean preview) {
		var assetSource = jsonEditor.getProperty(s3Config.tracker, assetKey);
		if (preview) {
			savecontent variable="local.generatedContent" {
				cfimage(action='writeToBrowser' source='#s3Config.path#/#assetSource#' height='52');
			}
			local.generatedContent = "
				<div class='fix-logo-lucee-bug'>#local.generatedContent#</div>
				<script>
					$(function(){
						console.log($('.fix-logo-lucee-bug img').length);
						$('.fix-logo-lucee-bug img').removeAttr('width').removeAttr('height');
					});
				</script>
			";
		} else {
			local.generatedContent = '<img src="./#assetSource#" title="Logo - Stratware.net">';
		}

		return local.generatedContent;
	}

	public string function getScripts(required string assetKey, required boolean preview) {
		return jsonEditor.getProperty(s3Config.tracker, assetKey);
	}

	public string function getFullFilePathByKey(required string assetKey) {
		return jsonEditor.getProperty(s3Config.tracker, assetKey);
	}

	public void function generateS3Asset(required string fileContents, required string fileName) {
		fileWrite("#s3Config.path#\#fileName#", fileContents);
	}
}