module example.app;

import std.stdio;
import std.file;
import std.conv;
import std.datetime;


import markdata.parser;
import markdata.deserializer;

class Info
{
	int Year;
	string Author;
	@MetaKey("Some other data")
	string[] OtherData;
	@MetaKey("Date")
	Date date;
	@MetaKey("DateTime")
	DateTime dateTime;
}

void main()
{
	string md = readText("example.md");

	auto meta = parseMetadata(md);
	
	writeln("Metadata:");
	writeln(meta.data);
	
	writeln();

	writeln("Remaining Text:");
	writeln(meta.remainingText);
	
	writeln();

	writeln("Serialized:");
	Info inf = deserializeMetadata!Info(meta.data);
	writeln("Author: \t" ~ inf.Author);
	writeln("Other Data: \t" ~ inf.OtherData.to!string());
	writeln("Year: \t\t" ~ inf.Year.to!string());
	writeln("Date: \t\t" ~ inf.date.to!string());
	writeln("DateTime: \t" ~ inf.dateTime.to!string());

}