Create new console app.

```
dotnet new console -o <appname>
cd <appname>
```

Add CliWrap Reference.

```
dotnet add package CliWrap --version 3.4.0
```

Use below code to get output from command (buffered async).
```
using CliWrap;
using CliWrap.Buffered;

var result = await Cli.Wrap("pwd")
                .ExecuteBufferedAsync();

Console.WriteLine(result.StandardOutput);
```


