## MATLAB Settings Handler

settings_handler defines a class for handling user settings for code projects in a transparent way. 

# What does it do?
settings_handler reads a YAML file that defines the location of a default settings file and a 
a user settings file that may be modified. From this, settings_handler creates what outwardly
looks like a structure (settings may be nested in a tree-like fashion) containing the user settings from the YML
file. In reality, each value in the structure is an object that handles reading and writing to the YML file on disk. 
The following are then possible:


1. Each time a value is accessed, it is read from disk.
2. If a value is re-assigned, it is immediately written to disk. 
3. If the user-specific settings file does not exist, it is automatically created from the default file. 
4. If a setting exists in the default settings file and not the user file, the value in the default file 
is automatically read. If this value is modified, the modified value is writen to the user settings file. 


# Example session

```MATLAB
%change to directory containing the example YML files
>> cd examples/example_one 

%Directory contains these two files.
>> ls
defaultSettings.yml  exampleSettingsFile.yml

```
The file ```defaultSettings.yml``` contains the settings data only and the file ```exampleSettingsFile.yml``` contains the location of the default settings file and the location where we will keep the user settings. So it simply contains the following two lines:

```ini
default: defaultSettings.yml
user: userSettings.yml
```

We create an instance of the settings_handler object as follows:
```MATLAB
>> S=settings_handler('exampleSettingsFile.yml')
No user settings file found at userSettings.yml. Creating default file using defaultSettings.yml
  elephantMonitor: [1x1 struct]
      ferretNames: [1x3 cell]
    ferretsPerBox: [1x3 double]
             font: [1x1 struct]
  numberOfFerrets: [1x1 double]
  pathToSomething: [1x15 char]

```
The instance, S, is created and reports back that that userSettings.yml file has been created. We verify this:

```
>> ls
defaultSettings.yml  exampleSettingsFile.yml  userSettings.yml
```

We can now read settings. For example, we can read from the cell array of strings and also index as norma:
```MATLAB

>> S.ferretNames

ans = 

    'albert'    'william'    'richard'

>> S.ferretNames{2}

ans =

william

>> S.ferretNames{2}(1:3)

ans =

wil
```

We can read from the nested data "font":
```MATLAB
>> S.font

ans = 

    name: [1x1 setting]
    size: [1x1 setting]
%Note the above reported type (setting) will be fixed soon. This is a minor bug

>> S.font.name

ans =

Helvetica

>> S.font.size

ans =

    10
```

We can also *modify* values. e.g.
```MATLAB
>> S.numberOfFerrets

ans =

    15

>> S.numberOfFerrets=99;
>> S.numberOfFerrets

ans =

    99

>> clear S
>> S
Undefined function or variable 'S'.
 
>> S=settings_handler('exampleSettingsFile.yml')
  elephantMonitor: [1x1 struct]
      ferretNames: [1x3 cell]
    ferretsPerBox: [1x3 double]
             font: [1x1 struct]
  numberOfFerrets: [1x1 double]
  pathToSomething: [1x15 char]
>> S.numberOfFerrets

ans =

    99

```

If you look in the files, you will see that ```defaultSettings.yml``` still says "15"  whereas ```userSettings.yml``` says "99".

# Location of the user settings YML

- If you want to make a hidden settings file in the user home directory then try ```user: ~/.userSettings.yml```. MATLAB is clever and expands the ```~``` correctly on Windows. 

- If you want to make a temporary settings file then try ```user: /tmp/userSettings.yml```. MATLAB is clever should translate the ```/tmp/``` to some sensible temporary directory on Windows. 