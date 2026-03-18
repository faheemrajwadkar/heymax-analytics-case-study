import json
import os

def merge_dbt_docs():
    target_path = './dbt/heymax/target'
    
    with open(os.path.join(target_path, 'index.html'), 'r') as f:
        content = f.read()

    with open(os.path.join(target_path, 'manifest.json'), 'r') as f:
        manifest = json.load(f)

    with open(os.path.join(target_path, 'catalog.json'), 'r') as f:
        catalog = json.load(f)

    # Search and replace the placeholders in dbt's index.html
    new_content = content.replace(
        '"{% dict manifest %}"', json.dumps(manifest)
    ).replace(
        '"{% dict catalog %}"', json.dumps(catalog)
    )

    with open(os.path.join(target_path, 'static_index.html'), 'w') as f:
        f.write(new_content)
    
    print("Static documentation generated at target/static_index.html")

if __name__ == "__main__":
    merge_dbt_docs()