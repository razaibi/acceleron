Code to read CSV file.

Sample CSV file:

```text
Username,Identifier,First name,Last name
booker12,9012,Rachel,Booker
grey07,2070,Laura,Grey
johnson81,4081,Craig,Johnson
jenkins46,9346,Mary,Jenkins
smith79,5079,Jamie,Smith
```

Typeless Version:

```csharp
using System.Globalization;
using CsvHelper;

using (var reader = new StreamReader("users.csv"))
using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
{
    var records = csv.GetRecords<dynamic>();

    foreach(var record in records){
        Console.WriteLine(record.Username);
    }
}
```


Typed Version:

```csharp
using System.Globalization;
using CsvHelper;

public class User
{
    public string? Username { get; set; }
    public int Identifier { get; set; }
    public string? Firstname { get; set; }
    public string? Lastname { get; set; }
    public User(){}
}

using (var reader = new StreamReader("users.csv"))
using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
{
    var records = csv.GetRecords<User>();

    foreach(var record in records){
        Console.WriteLine(record.Username);
    }
}
```
