## Generator

- Create folders using below.

```bash
mkdir data
mkdir flows
mkdir output
mkdir templates
```

- Create file **requirements.txt**.

```txt
PyYAML==6.0
Jinja2==3.1.2
```

- Create file **data/sample.yml**.

```yml
name: "World"
```

- Create file **flows/sample.yml**.

```yml
- data: "sample.yml"
  template: "sample.j2"
  output: "output1.txt"
```

- Create file **templates/sample.j2**.

```yml
Hello, {{ data.name }}
```

- Create **main.py**

```python
import os
import sys
import yaml
from jinja2 import Environment, FileSystemLoader

def main():
    for flow in sys.argv[1:]:
        flow_path = os.path.join('flows', f'{flow}.yml')
        print(f'Processing Flow : {flow_path}.')
        # Load the items from the YAML file
        with open(
                flow_path
            ) as f:
            items = yaml.safe_load(f)
            process_items(items)
        print(f'Flow Status: Done.\n')

def process_items(items):
    # Set up the Jinja2 environment
    env = Environment(loader=FileSystemLoader('templates'))
    # Loop through the items and generate the output files
    for item in items:
        # Load the source data
        try:
            data_path = os.path.join('data', item['data'])
            with open(
                data_path,
                ) as f:
                data = yaml.load(f, Loader=yaml.FullLoader)
        except:
            print(f'Error reading {data_path}.')

        # Load the template
        template = env.get_template(item['template'])

        # Render the template with the source data
        output = template.render(data=data)

        # Save the output to the specified output file
        output_path = os.path.join('output', item['output'])
        try:
            with open(
                output_path, 
                'w'
                ) as f:
                f.write(output)
        except:
            print(f'Error writing output {output_path}.')

if __name__=='__main__':
    main()
```

- Create file **install.sh**

```bash
pip install -r requirements.txt
```

- Set permission on the install.sh

```bash
chmod +x install.sh
```




