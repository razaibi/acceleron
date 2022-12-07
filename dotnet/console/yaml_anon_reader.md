```csharp
using YamlDotNet.Serialization.NamingConventions;
using System.Dynamic;

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

var deserializer = new YamlDotNet.Serialization.DeserializerBuilder()
    .WithNamingConvention(UnderscoredNamingConvention.Instance)
    .Build();

dynamic myConfig = deserializer.Deserialize<ExpandoObject>(yml);

System.Console.WriteLine($"{myConfig.name}");

```