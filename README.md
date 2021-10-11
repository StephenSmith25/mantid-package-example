# Mantid packaging
This project was created to test new packaging strategies for Mantid. With the move to a conda first approach in Mantid, the old packaging will no longer work. When approaching the issue of package development we were left with two approaches,

- Create a standalone executable containing everything required to run mantid. This is how we currently do packaging.
- Create a online installer, which at install time would fetch everything required to use Mantid, e.g from conda.

At the time of writing, it was decided to proceed with the first option. Primarily this was chosen to:

- Keep a installer which is similar to what users expect and are used to.
- Creating an online based installer will require a certain degree of "hacking" together. 
- Creating an install script, which would both fetch the required binaries and lay them out in a package structure would be difficult to maintain.
- Bundling up a complete package will allow us to utilise standard tools, e.g CMake and CPack. 

Currently, the goal of the new packaging design is to create a fully contained bundle.

The last point was important in our decision. Over the last few versions, CMake have made improvements in dealing with installing run time dependencies, e.g with:
```
file(GET_RUNTIME_DEPENDENCIES
  [RESOLVED_DEPENDENCIES_VAR <deps_var>]
  [UNRESOLVED_DEPENDENCIES_VAR <unresolved_deps_var>]
  [CONFLICTING_DEPENDENCIES_PREFIX <conflicting_deps_prefix>]
  [EXECUTABLES [<executable_files>...]]
  [LIBRARIES [<library_files>...]]
  [MODULES [<module_files>...]]
  )
```
To grab all runtime dependencies of a certain library or executable. And more recently and optional argument to install to all install a libraries runtime requirements. 
```
install(TARGETS targets...
        [RUNTIME_DEPENDENCIES args...|RUNTIME_DEPENDENCY_SET <set-name>]
        )
```
This shows that despite the rise of package managers (e.g conda), CMake are still improving the packaging tools available to developers.

The standalone installers we provide will also sit along side a set of conda packages:
```
mantid-framework
mantid-qt
mantid-workbench
```
which may be installed using the traditional conda approach, i.e.

```
conda install mantid-framework
```
# Considerations
As a first thought we considered modifying the current packaging scripts to look (and copy) for libraries in the conda prefix rather than the system folders. For libraries such as boost, this would just copy the runtime dependencies into our package, as 

```
conda_env/bin/libboost_math.dylib -> MantidWorkbench/lib/libboost_math.dylib
```
For libraries such as this, provided we resolve their dependencies using otool, or another object viewer, this works as libraries such as this should be full relocatable. The issues comes with copying and packaging python. The spyder developers suggested that packaging up an anaconda python executable does not work (possibly)
```
Quote from a spyder developer regarding packaging:

"In principle, it doesn't matter where your Python installation comes from except that it cannot come from Anaconda. I do not know exactly why an Anaconda installation does not work except that it has something to do with hardlinks."
```

This meant we had to consider a new approach.

# Prototype design #1
## Currently only tested on OSX. 
This was influenced by the application juypter have recently started shipping. Their application shares some similarities with mantid,

- Contains a GUI based application
- Nested inside the GUI application sits a python instance

To solve the issue of satisfying the python dependency, juypter used the conda constructor tool. This tool creates (.sh, pkg, exe) pacakges which can be used to install a conda environment specified by a .yaml file, e.g:
```
name: MyPackage
version: X
installer_type: all

channels:
  - conda-forge

specs:
  - python
  - conda
```
which would create a package named "MyPackage" which installs conda and python. Jupyter bundle a conda constructor installer (in the form a shell script) into their application bundle. While installing Juypterlab_app this shell script is executed, placing a full conda python package into their application. The GUI application can then launch and use this python environment.  


## Build instructions

- Create the conda environment
```
conda env create -f ./developer-env.yml
conda activate mantid-package
```
- Setup the build
```
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=../../my_install_folder
```
- Run the build
```
make -j4
make install
cpack
```

## The .pkg installer 
The above steps should create a .pkg installer in the build folder. The pkg contains a conda constructor installer for a python environment. This environment would contain all the python dependencies required by mantid. It is automatially installed with a postinstall script during the package installation. This script contains the following:
```
#!/bin/bash

sh /Applications/MantidPrototype.app/Contents/Resources/env_installer/MantidPython-0.1.0-MacOSX-x86_64.sh -b -u -p /Applications/MantidPrototype.app/Contents/Resources/mantid_python
exit 0
```

Once the pkg is executed it installs a package in Applications with the following layout:
```
MantidPrototype
│
└───Contents
│   │
│   └───MacOs
│   │     │- MantidPrototype
│   │     │- Mylib.dylib
│   │         
│   └───Framework
│   │     │- libqt5gui.dylib
│   │     │- libboost_math.dylib 
│   │         
│   └───Resources
│         │- env_installer/mantidpython.sh
│         │- mantid_python/
```


The `mantid_python` folder contains our full python environment created using the postinstall script and the installer from conda constructor. It would look something like

```
mantid_python
│
└───lib
│   │- libqt5gui
│   │- libc++
│   
│
└───bin
    │- conda
    │- python
```

If we ran `source activate ../Resources/mantid_python/bin` in the MacOS folder we would activate conda for that current shell. Meaning if we next launched python we would be inside our mantid_python environment. We could hyothetically combine these steps to create a suitable launch script Presumably the juypter app does something similar.


## Concerns
Some duplicated binaries. For instance, on Mac we typically bundle the qt libraries into the Frameworks folder, which is standard in osx applications. Within our python environment we have pyqt and qtpy listed as requirements. This unfortunately means that qt libraries are present in two locations within the package:

`MantidPrototype/Contents/Frameworks/libqt5gui.dylib`
`MantidPrototype/Contents/Resources/mantid_python/lib/libqt5gui.dylib`

I don't think this a particular issue outside of duplication (e.g a bigger package). THe alternative would be to not bundle qt in Frameworks and modify the `rpath` of binaries reliant on qt to point at `MantidPrototype/Contents/Resources/mantid_python/lib`

To pip install packages into the environment you'll have to run chown on the application on osx and linux, e.g
```
sudo chown -R username /opt/MantidWorkbench or on OSX
sudo chown -R username /Applications/MantidWorkbench 
```
# Prototype design #2