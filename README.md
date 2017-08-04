# MongDB Mobile

These are proof of concept apps that run embedded MongoDB. There are two applications in this repository, one written in swift and the other in objective c. Both are build on top of the C-Driver; however, the Swift application utliizes a full Swift Driver written on top of the c-driver. 

In order to run these applications, clone the repository, and execute the shell script sh runSetup.sh

Once the script is done, the application will be in the folder cross-built-mongo and and in order to run them on an iPad or iPhone (they will not work on the simulator) the object files in the directory objfiles must be added to the linked libraries secion in xCode. 

