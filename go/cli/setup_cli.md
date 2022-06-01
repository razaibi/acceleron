#### Create application folder.

```bash
mkdir newapp
cd newapp
go mod init newapp
```

#### Install Cobra CLI.
```bash
go install github.com/spf13/cobra-cli@latest
```

#### Initialize Cobra CLI.

```bash
cobra-cli init
```

#### Generate code to create new command.

```bash
cobra-cli add serve
```
