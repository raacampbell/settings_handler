## Settings Handler
This MATLAB class reads a YAML file and produces what outwardly looks like a structure. 
Each value in the structure is in fact an object that was read from the YML file on disk. 
Optionally, the file is re-read each time the value is accessed. Changing the value in the
structure also the changes the value on disk. 