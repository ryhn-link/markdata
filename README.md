# markdata
Markdata lets you parse and serialize [MultiMarkdown metadata](https://github.com/fletcher/MultiMarkdown/wiki/MultiMarkdown-Syntax-Guide#metadata). Additionally it returns a string without the metadata block  
markdata doesn't require any additional dependencies and is licensed under LGPL-3.0.  

## Examples
Examples can be found in the [examples folder](examples).  
Here's a snippet of code from the exaple:
```d
import std.file;
import markdata.parser;
import markdata.deserializer;

class Info
{
	int Year;
	string Author;
	@MetaKey("Some other data")
	string[] OtherData;
}

...

string md = readText("example.md");
auto meta = parseMetadata(md);

writeln("Metadata:");
writeln(meta.data);
// ["Project Name":["Markdata"], ...

writeln("Remaining Text:");
writeln(meta.remainingText);
// This is the **markdown** text ...

Info inf = deserializeMetadata!Info(meta.data);
writeln("Author: \t" ~ inf.Author);
// Author:         Ryhon ...
```