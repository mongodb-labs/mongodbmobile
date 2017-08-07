# MongoDB Mobile

This repository contains sample applications for the MongoDB Mobile project to create an embedded database capable of running locally on a smartphone. The repository contains two iOS applications: one written in Objective-C and the other in Swift using a prototype Swift driver. Furthermore, the repositry contains a script (runSetup.sh) that will pull a tagged version of Mongo and the C-Driver and then cross compile them for the iOS platform. Currently, the application will only build on a physical phone or ipad as opposed to the xCode simulator. 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
Xcode
iOS device to test application
```

### Installing

Run the script runSetup.sh by executing the command:
```
sh runSetup.sh
```

The only other step will be outputted by the script, but in the Xcode project you must navigate to the Build Phases tab and under the Link Binary With Libraries option click the plus button, then 'add other' and navigate the the recently created directory in the project folder titled 'objfiles' and add all of the object files in the folder. 

## Built With

* [Scons](http://scons.org/) - Build Tool Used
* [XCode](https://developer.apple.com/xcode/) - Application Framework
* [SwiftMongo](https://github.com/Danappelxx/SwiftMongoDB) - Basis of Swift Driver

## Contributing

Please read (https://github.com/mongodb/mongo/wiki) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Tyler Kaye** 
**Ted Tuckman** 
**Ben Shteinfeld**

## License

Most MongoDB source files (src/mongo folder and below) are made available
  under the terms of the GNU Affero General Public License (GNU AGPLv3). See
  individual files for details.

## Acknowledgments

Mentors: Andrew Morrow, Jason Carey, and all of the Server Platforms Team at MongoDB
