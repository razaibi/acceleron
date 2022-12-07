using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;
using YamlDotNet.RepresentationModel;
using Newtonsoft.Json.Linq;

var yml = @"
name: George Washington
age: 89
height_in_inches: 5.75
addresses:
  home:
    street: 400 Mockingbird Lane
    city: Louaryland
    state: Hawidaho
    zip: 99970
";

// var r = new StreamReader("sample.yaml"); 
// var deserializer = new DeserializerBuilder()
//     .WithNamingConvention(UnderscoredNamingConvention.Instance)  // see height_in_inches in sample yml 
//     .Build();
// var yamlObject = deserializer.Deserialize(r);




// Newtonsoft.Json.JsonSerializer js = new Newtonsoft.Json.JsonSerializer();

// var w = new StringWriter();
// js.Serialize(w, yamlObject);
// string jsonText = w.ToString();
		



// dynamic customer2 = JObject.Parse(jsonText);

var serializer = new SerializerBuilder()
    .WithNamingConvention(CamelCaseNamingConvention.Instance)
    .Build();
var yaml = serializer.Serialize(object);

System.Console.WriteLine($"{yaml}");