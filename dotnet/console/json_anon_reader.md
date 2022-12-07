using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

var definition = new { Name = "" };

string json1 = @"{'Name':'James'}";
string json2 = @"{'Name':'James', 'Place':'Dallas'}";
var customer1 = JsonConvert.DeserializeAnonymousType(json1, definition);
dynamic customer2 = JObject.Parse(json2);

Console.WriteLine(customer1?.Name);
Console.WriteLine(customer2?.Place);