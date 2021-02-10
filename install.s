/**
 * PyLo installer/upder
 */

if(!ContinueCancelDialog("Install/Update pylo")){
    exit(0);
}

string text;
string python_code;

string version_request = "https://raw.githubusercontent.com/miile7/pylo-gms/master/VERSION"
string repository = "https://github.com/miile7/pylo-gms/"

// = = = find pylo install path = = =
String pylo_install_path;

// use path from tags
String pylo_tagname = "Pylo Install Path";
if(!GetPersistentTagGroup().TagGroupGetTagAsString(pylo_tagname, pylo_install_path)){
    pylo_install_path = "";
}

// path is not saved, try to find the python file in the GMS plugin directories
if(pylo_install_path == ""){
    TagGroup application_paths = NewTagList();
    application_paths.TagGroupInsertTagAsString(infinity(), GetApplicationDirectory("application", 0));
    application_paths.TagGroupInsertTagAsString(infinity(), GetApplicationDirectory("plugin", 0));
    application_paths.TagGroupInsertTagAsString(infinity(), GetApplicationDirectory("executable", 0));
    application_paths.TagGroupInsertTagAsString(infinity(), GetApplicationDirectory("core", 0));
    application_paths.TagGroupInsertTagAsString(infinity(), GetApplicationDirectory("preference", 0));
    application_paths.TagGroupInsertTagAsString(infinity(), GetApplicationDirectory("current", 0));
    application_paths.TagGroupInsertTagAsString(infinity(), "%userdata%");
    application_paths.TagGroupInsertTagAsString(infinity(), "%userdata%".PathConcatenate("pylo"));

    for(number i = 0; i < application_paths.TagGroupCountTags(); i++){
        String dir;
        if(application_paths.TagGroupGetIndexedTagAsString(i, dir)){
            if(dir.DoesDirectoryExist()){
                TagGroup sub_dirs = dir.GetFilesInDirectory(2);
                sub_dirs.TagGroupInsertTagAsString(infinity(), "");
                for(number j = 0; j < sub_dirs.TagGroupCountTags(); j++){
                    String file;
                    String sub_dir_name;
                    sub_dirs.TagGroupGetIndexedTagAsString(j, sub_dir_name);

                    if(sub_dir_name == "." || sub_dir_name == ".."){
                        continue;
                    }
                    else if(sub_dir_name == ""){
                        file = dir.PathConcatenate("start.py");
                    }
                    else{
                        file = dir.PathConcatenate(sub_dir_name).PathConcatenate("start.py");
                    }

                    if(file.DoesFileExist()){
                        pylo_install_path = dir;
                        break;
                    }
                }
            }
        }
    }
}

// use current file as fallback
if(pylo_install_path == ""){
    DocumentWindow win = GetDocumentWindow(0);
    if(win.WindowIsvalid()){
        if(win.WindowIsLinkedToFile()){
            String current_path = win.WindowGetCurrentFile();
            pylo_install_path = current_path.PathExtractParentDirectory(0);
        }
    }
}

if(pylo_install_path == "" || !pylo_install_path.DoesFileExist()){
    if(!ContinueCancelDialog("Please press 'Continue' and select the destination path to install PyLo to. The recommended location is " + GetApplicationDirectory("plugin", 1) + ".")){
        exit(0);
    }
}
else{
    if(!TwoButtonDialog("Found installation directory " + pylo_install_path + ". Do you want to use this?", "Yes", "No, change it")){
		pylo_install_path = "";
    }
}

// let the user select the installation path
if(pylo_install_path == "" || !pylo_install_path.DoesDirectoryExist()){
    if(!GetDirectoryDialog(NULL, "Select pylo install directory", GetApplicationDirectory("plugin", 1), pylo_install_path)){
        exit(0);
    }
}

if(pylo_install_path == ""){
    throw("The installation path is empty.");
}
else if(!pylo_install_path.DoesDirectoryExist()){
    throw("The installation path '" + pylo_install_path + "' does not exist.");
}

// save the install path
GetPersistentTagGroup().TagGroupSetTagAsString(pylo_tagname, pylo_install_path);

// = = = Check if an installation is needed at all = = =

// // try to find a version
// number installation_required = 0;
// if(pylo_install_path.PathConcatenate("pylo").DoesDirectoryExist()){
//     string version;
// 	string version_file = pylo_install_path.PathConcatenate("pylo").PathConcatenate("VERSION");

//     if(version_file.DoesFileExist()){
//         number encoding = 0; // current encoding
//         number file_reference = OpenFileForReading(version_file);

//         object file_stream = NewStreamFromFileReference(file_reference, 0);
//         file_stream.StreamSetPos(0, 0);
//         string version = file_stream.StreamReadAsText(encoding, file_stream.StreamGetSize());

//         CloseFile(file_reference);
//     }

//     if(version == ""){
//         installation_required = 2;
//     }
//     else{
//         string installation_required_tagname = "__install_pylo_installation_required";

//         // load online version and compare version with the current version
//         python_code = "";
//         python_code += "import DigitalMicrograph as DM\n";
//         python_code += "try:\n";
//         python_code += "    import requests\n";
//         python_code += "except ImportError as e:\n";
//         python_code += "    raise ImportError(\"The python requests module is missing. Either install this module manually or install pylo manually.\") from e\n";
//         python_code += "\n";
//         python_code += "offline_version = tuple(map(int, \"" + version + "\".split(\".\")))\n";
//         python_code += "url = \"" + version_request + "\"\n";
//         python_code += "r = requests.get(url)\n";
//         python_code += "online_version = tuple(map(int, r.content.split(\".\")))\n";
//         python_code += "installation_required = len(online_version) > len(offline_version) or online_version > offline_version\n"
//         python_code += "DM.GetPersistentTagGroup().SetTagAsShort(\"" + installation_required_tagname + "\", int(installation_required))\n";
        
//         try{
//             ExecutePythonScriptString(python_code)
//         }
//         catch{
//             installation_required = 3;
//         }

//         if(!GetPersistentTagGroup().TagGroupGetTagAsShort(installation_required_tagname, installation_required)){
//             installation_required = 3;
//         }
//         GetPersistentTagGroup().TagGroupDeleteTagWithLabel(installation_required_tagname);
//     }
// }
// else{
//     installation_required = 2;
// }

// if(installation_required == 1){
//     text = "There is a newer version of PyLo found. Do you want to update?"
// }
// else if(installation_required == 2){
//     text = "Do you want to start the installation?"
// }
// else if(installation_required == 3){
//     text = "Could not detect the lastest version (is there an internet connection). Do you want to update/(re-)install PyLo?"
// }

// if(!TwoButtonDialog(text, "Yes (recommended)", "No, exit")){
//     exit(0);
// }

// // = = = start download and extraction = = =

// if(TwoButtonDialog("Do you want to use the python package manager to install PyLo?", "Yes (recommended)", "No, manual installation")){
//     // intall pylo gms program
//     python_code = ""
//     python_code += "import os\n";
//     python_code += "import zipfile\n";
//     python_code += "import datetime\n";
//     python_code += "try:\n";
//     python_code += "    import requests\n";
//     python_code += "except ImportError as e:\n";
//     python_code += "    raise ImportError(\"The python requests module is missing. Either install this module manually or install pylo manually.\") from e\n";
//     python_code += "\n";
//     python_code += "url = \"" + repository + "/archive/master.zip\"\n";
//     python_code += "r = requests.get(url)\n";
//     python_code += "install_dir = \"" + pylo_install_path + "\n";
//     python_code += "zip_path = os.path.join(install_dir, \"pylo-patch-{%Y-%m-%d}.zip\".format(datetime.datetime.now())\n";
//     python_code += "with open(zip_path, \"wb\") as zip:\n";
//     python_code += "    zip.write(r.content)\n";
//     python_code += "with zipfile.ZipFile(zip_path, 'r') as zip_ref:\n";
//     python_code += "    zip_ref.extractall(install_dir)\n"
// }
// else{
//     text = "You chose a manual installation.\n\n";
//     text += "Please download the complete program source code including the module code by ";
//     text += "downloading the repository code from <https://github.com/miile7/pylo/archive/master.zip>.\n\n"
//     text += "Continue if the files are downloaded."

//     if(!ContinueCancelDialog(text)){
//         exit(0);
//     }

//     text = "Now extract the files form the zip file. Copy or move the 'pylo' directory into ";
//     text += "'" + pylo_install_path + "'."

//     if(!ContinueCancelDialog(text)){
//         exit(0);
//     }
// }

// = = = Create menu items = = =

String menu_file;

number installed_menus = 0;

// start pylo menu item
menu_file = pylo_install_path.PathConcatenate("start.s");
if(!menu_file.DoesFileExist()){
    throw("The pylo execution file '" + menu_file + "' does not exist. Please restart the installer.");
}
else{
	AddScriptFileToMenu(menu_file, "Start measurement", "PyLo", "", 0);
    installed_menus++;
}

// list devices directories
menu_file = pylo_install_path.PathConcatenate("settings.s");
if(menu_file.DoesFileExist()){
    AddScriptFileToMenu(menu_file, "Show settings", "PyLo", "", 0);
    installed_menus++;
}

// list devices directories
menu_file = pylo_install_path.PathConcatenate("devices.s");
if(menu_file.DoesFileExist()){
    AddScriptFileToMenu(menu_file, "List device directories", "PyLo", "", 0);
    installed_menus++;
}

// clear trash
menu_file = pylo_install_path.PathConcatenate("clear_trash.s");
if(menu_file.DoesFileExist()){
    AddScriptFileToMenu(menu_file, "Clear trash", "PyLo", "", 0);
    installed_menus++;
}

// reset settings
menu_file = pylo_install_path.PathConcatenate("path.s");
if(menu_file.DoesFileExist()){
    AddScriptFileToMenu(menu_file, "Change installation path", "PyLo", "", 0);
    installed_menus++;
}

// reset settings
menu_file = pylo_install_path.PathConcatenate("reset.s");
if(menu_file.DoesFileExist()){
    AddScriptFileToMenu(menu_file, "Reset settings", "PyLo", "", 0);
    installed_menus++;
}

OkDialog("Done with installation. Installed " + installed_menus + "/6");