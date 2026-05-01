class_name KeywordService
extends RefCounted

const KEYWORD_DATA: Dictionary = preload("res://sauce/keywords/keyword_data.json").data


static func parse_text(text: String) -> String:
	var parsed_text: String = text
	var regex := RegEx.create_from_string("(%s)" % "|".join(KEYWORD_DATA.keys()))
	parsed_text = regex.sub(parsed_text, "[url=$1][u]$1[/u][/url]", true)
	return parsed_text


static func get_description(keyword: String) -> String:
	return KEYWORD_DATA[keyword]["description"]
