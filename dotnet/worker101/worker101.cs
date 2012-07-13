using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Linq;

abstract
public class HelloWorld
{
	static public void Main (string[] args)
	{
	string query = "iron";
	Dictionary<string,string> values = ParsePayload(args);
	string[] keys = values.Keys.ToArray();

	foreach(string key in keys)
		{
		    if (key=="query") {
		    query = values[key];
		    }
		}
    System.Console.WriteLine("Query = {0}", query);



	string lines = "some text1,some text2,some text3";
    File.WriteAllText(@"someText.txt", lines);
    string text = File.ReadAllText(@"someText.txt");
    System.Console.WriteLine("Contents of WriteText.txt = {0}", text);

	}


	static private Dictionary<string,string> ParsePayload(string[] args){
	int payloadIndex=-1;
    	 for (var i = 0; i < args.Length; i++)
                {
                Console.WriteLine(args[i]);
                    if (args[i]=="-payload")
                     {
                        payloadIndex = i;
                        break;
                     }
                }
                if (payloadIndex == -1) {
                        Console.WriteLine("Payload is empty");
                        Environment.Exit(0);
                    }

                    if (payloadIndex >= args.Length-1) {
                            Console.WriteLine("No payload value");
                            Environment.Exit(0);
                        }

    	    string json = File.ReadAllText(args[payloadIndex+1]);
    	    var jss = new JavaScriptSerializer();
    	    Dictionary<string, string> values = jss.Deserialize<Dictionary<string, string>>(json);
    	    return values;
	}
}