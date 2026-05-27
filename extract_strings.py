import os
import re

def to_camel_case(text):
    s = re.sub(r'[^a-zA-Z0-9\s]', '', text)
    words = s.split()
    if not words:
        return "emptyString"
    return words[0].lower() + ''.join(w.capitalize() for w in words[1:])

lib_dir = '/Volumes/AkshyaSpace/Developer/voicly_projects/voicly_user/lib'
strings_dict = {}

pattern = re.compile(r'(Text\(\s*|hintText:\s*|labelText:\s*|label:\s*Text\(\s*|text:\s*)(["\'])(.*?)\2')

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    replacements = []
    
    for match in pattern.finditer(content):
        prefix = match.group(1)
        quote = match.group(2)
        text = match.group(3)
        
        # Skip if it contains string interpolation
        if '$' in text:
            continue
            
        # Skip empty or very short non-word strings
        if len(text.strip()) == 0:
            continue
            
        key = to_camel_case(text)
        
        original_key = key
        counter = 1
        while key in strings_dict and strings_dict[key] != text:
            key = f"{original_key}{counter}"
            counter += 1
            
        strings_dict[key] = text
        
        replacement = f"{prefix}AppStrings.{key}"
            
        replacements.append((match.start(), match.end(), replacement))
        
    if replacements:
        replacements.sort(key=lambda x: x[0], reverse=True)
        new_content = content
        for start, end, repl in replacements:
            new_content = new_content[:start] + repl + new_content[end:]
            
        # Add import
        import_stmt = "import 'package:voicly/core/constants/app_strings.dart';\n"
        if import_stmt not in new_content:
            first_import = new_content.find('import ')
            if first_import != -1:
                new_content = new_content[:first_import] + import_stmt + new_content[first_import:]
            else:
                new_content = import_stmt + new_content
                
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)

for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart') and file != 'app_strings.dart':
            process_file(os.path.join(root, file))

app_strings_path = os.path.join(lib_dir, 'core', 'constants', 'app_strings.dart')
os.makedirs(os.path.dirname(app_strings_path), exist_ok=True)

with open(app_strings_path, 'w', encoding='utf-8') as f:
    f.write('class AppStrings {\n')
    for key, text in sorted(strings_dict.items()):
        safe_text = text.replace("'", "\\'")
        f.write(f"  static const String {key} = '{safe_text}';\n")
    f.write('}\n')

print(f"Extracted {len(strings_dict)} strings.")
