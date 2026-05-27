import os

lib_dir = '/Volumes/AkshyaSpace/Developer/voicly_projects/voicly_user/lib'

# Rename in all files
for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
                
            new_content = content.replace('AppStrings.', 'AppText.')
            # Also update the import if it exists
            # Wait, the file is currently named app_strings.dart, I should rename the import
            new_content = new_content.replace("import 'package:voicly/core/constants/app_strings.dart';", "import 'package:voicly/core/constants/app_text.dart';")
            
            if new_content != content:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)

app_strings_path = os.path.join(lib_dir, 'core', 'constants', 'app_strings.dart')
app_text_path = os.path.join(lib_dir, 'core', 'constants', 'app_text.dart')

if os.path.exists(app_strings_path):
    with open(app_strings_path, 'r', encoding='utf-8') as f:
        content = f.read()
    content = content.replace('class AppStrings', 'class AppText')
    with open(app_text_path, 'w', encoding='utf-8') as f:
        f.write(content)
    os.remove(app_strings_path)

print("Renamed AppStrings to AppText")
