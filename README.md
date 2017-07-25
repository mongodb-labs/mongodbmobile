# MongoEmbeddedContactsApp

Configuring the App --> uise the script

1. Build Phases: 
	Link with Libraries --> add in the object files path
	Add libmongoc.a and libbson.a

2. Build Settings: under all
	Always search users path: true
	Other Linker Flags --> add "-all_load"
					   --> add "-lstdc++"

	Header Search Paths: (all non-recursive)
		1. Add path to the embedded mongo folder: 
		2. Add paths to the two folders with the libraries for the c driver: 
		3. Add path to the mongo repo


	Library Search Paths: (all non-recursive)
		1. Add path to the ojb (.a) files: 
		2. Add path to the lib directory of the cdriver: 
