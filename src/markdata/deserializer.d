module markdata.deserializer;

import std.stdio;
import std.conv;
import std.array;
import std.datetime;
import std.traits;
import std.exception;

/// Property name attribute
struct MetaKey
{
	/// Property name
	string name;
}

/// Serialize string[][string] into class or struct
T deserializeMetadata(T)(string[][string] data)
{
	T var;
	static if(is(T == class)) var = new T;
	else static if(is(T == class)) var = T();

	foreach (i, ref field; var.tupleof)
	{
		// Get field name
		string name = __traits(identifier, var.tupleof[i]);

		// Check if property exists
		// Use field name
		if(name in data) 
		{
			var.tupleof[i] = parseValue!(typeof(var.tupleof[i]))(data[name]);
			continue;
		}
		// Use MetaKey AtAttribute
		foreach (at; __traits(getAttributes, var.tupleof[i]))
		{
			static if(is(typeof(at) == MetaKey))
			{
				name = at.name;
				if(name in data)
				{
					var.tupleof[i] = parseValue!(typeof(var.tupleof[i]))(data[name]);
					continue;
				}
			}
		}
	}
	return var;
}

/// Parse string[] into type
T parseValue(T)(string[] values)
{
	// string
	static if(is(T == string))
	{
		return join(values, "\n");
	}
	// string[]
	else static if(is(T == string[]))
	{
		return values;
	}
	else static if(is(T == Date))
	{
		return Date.fromISOExtString(join(values));
	}
	else static if(is(T == DateTime))
	{
		return DateTime.fromISOExtString(join(values));
	}
	// Iterable
	else static if( isIterable!T )
	{
		return to!T(values);
	}
	// Other
	else
	{
		return to!T(join(values));
	}
}

unittest
{
	// Can't instance a class inside a unit test, but structs work
	// Classes work fine outside unit tests
	struct BlogPost
	{
		@MetaKey("Author") string author;
		@MetaKey("Tags") string[] tags;
		@MetaKey("Year") int year;
	}

	string md = 
"Author: JKR
Tags: Based
Harry Potter
Popular
Year: 2021

blah blah blah based blah";
	
	import markdata;

	BlogPost post = serializeMetadata!BlogPost(parseMetadata(md).data);

	assert(post.author == "JKR");
	assert(post.tags == ["Based", "Harry Potter", "Popular"]);
	assert(post.year == 2021);
}