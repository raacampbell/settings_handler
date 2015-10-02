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

