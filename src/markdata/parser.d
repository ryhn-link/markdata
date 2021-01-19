module markdata.parser;

import std.stdio;
import std.string;
import std.algorithm : canFind;

/// Markdown metadata class
class MarkdownMetadata
{
	/// Metadata
	string[][string] data;
	/// Text without the metadata
	string remainingText;

	this(string[][string] d, string r)
	{
		data = d;
		remainingText = r;
	}
}

/// Get metadata from a markdown file
MarkdownMetadata parseMetadata(string md)
{
	string[][string] data;

	// Split text into lines
	string[] lines = splitLines(md);

	string currentKey;
	int currentLine;

	for (currentLine = 0; currentLine < lines.length; currentLine++)
	{
		string line = lines[currentLine];

		// Check if line is empty and ends the metadata block
		if (strip(line) == "")
			break;

		// Check if line is a new key
		int colonId = cast(int) indexOf(line, ":");
		if (colonId != -1)
		{
			currentKey = strip(line[0 .. colonId]);
			string value = strip(line[colonId + 1 .. $]);

			data[currentKey] = [value];
		}
		// Not a key, it's a value
		else
		{
			// No previous key found, no metadata in text
			if (currentKey == null)
			{
				currentLine = 0;
				break;
			}

			// Add a value to the last key
			data[currentKey] ~= strip(line);
		}
	}

	int remainingIndex = 0;
	if(currentLine != 0)
		foreach (line; lines[0..currentLine+1])
		{
			remainingIndex += line.length + 1;
		}

	return new MarkdownMetadata(data, md[remainingIndex .. $]);
}

unittest
{
	string md = 
"Author: 	Ryhon  
Year: 		2021
Array: 		a
	b
				c
			d

Remaining Text";
	auto meta = parseMetadata(md);

	assert(meta.data["Author"] == ["Ryhon"]);
	assert(meta.data["Year"] == ["2021"]);
	assert(meta.data["Array"] == ["a", "b","c","d"]);
	
	assert(meta.remainingText == "Remaining Text");
}