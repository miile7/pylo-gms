# PyLo GMS/DigitalMicrograph Frontend

This repository contains the integration of PyLo into DigitalMicrograph. This will add 
menu items and the corresponding scripts to access all the functionality of PyLo easily.

> PyLo is a Python module and program for recording Lorentz-TEM images.
> 
> The software is written for the JEOL NeoArm F200 with Gatan Microscopy Suite as the 
> displaying software but can be extended to use any microscope. Also it comes with a 
> command line view, that does not need Gatan Microscopy Suite.
> 
> PyLo provides an easy to understand GUI to create highly customizable measurement series 
> to automatically record changes in magnetic orders. With the JEOL NeoArm F200, PyLo allows
> creating series over the tilt in x and y direction, the (de-)focus and the magnetic field
> applied by activating the objective lenses.
> 
> PyLo is easily extended. It provides an Event system to hook in before or after specific
> actions. It allows to use and change all settings at any time. Also it provides an easy to 
> use settings manager where plugins can add their settings which will be shown to the user 
> before every measurement run. Microscopes and cameras can be customized or replaced by 
> creating own classes that implement an interface. Those classes can be loaded dynamically.
> This way PyLo can deal with every microscope and camera without having to learn the whole
> program code. 

## Installation (Internet connection+Windows only)

To install PyLo completely you need to install the PyLo core plus the files from here. To
do so, follow this steps:

1. [Download all files](https://github.com/miile7/pylo-gms/archive/master.zip)
2. Open the downloaded zip file and copy the files (not the `pylo-gms-master` directory
   but the files inside) into `%programdata%\Gata\Plugins\pylo`. If the `Plugins` directory 
   does not exist, create it. Also create the `pylo` directory. (Note that using 
   `%programdata%\Gata\Plugins\pylo` is not necessary. PyLo will also work for other 
   directories. It just makes sens to keep the files here.)
3. Execute the `install-python-env.bat`. This will prepare the python environment and 
   download the PyLo core for you (note that an internet connection is required)
4. Now you can integrate PyLo into DigitalMicrograph by opening the `install.s` file in 
   DigitalMicrograph and executing it.

If you do not have an internet connection install the PyLo core manually from the 
[core repository](https://github.com/miile7/project-pylo/). After that do Step 1, 2 and 4

If you Unix PyLo still does work for you. In this case please install the command line 
version of PyLo from the [core repository](https://github.com/miile7/project-pylo/).