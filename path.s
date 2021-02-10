// let the user confirm the reset
String text = "Change the PyLo installation path.\n\n";
text += "Select the 'start.py' file in your PyLo GMS installation. (This is the files that ";
text += "you donwloaded manually.) The 'start.py' file probably is in one of the following ";
text += "directories or in a subdirectory:\n"
text += "- " + GetApplicationDirectory("application", 0) + "\n";
text += "- " + GetApplicationDirectory("plugin", 0) + "\n";
text += "- %userdata%\n";
text += "\n";
text += "Note that if you change this file to an invalid file, your PyLo program will not work anymore.";

if(!ContinueCancelDialog(text)){
    exit(0);
}

String default_path = GetApplicationDirectory("plugin", 0);
if(!default_path.DoesDirectoryExist()){
    default_path = "%userdata%";
}

String install_path;
if(!OpenDialog(NULL, "Select PyLo 'start.py'", default_path, install_path)){
    exit(0);
}

if(!install_path.DoesFileExist()){
    throw("The file '" + install_path + "' does not exist.");
}
else if(install_path.PathExtractExtension(0) != "py"){
    throw("The file '" + install_path + "' does not end with the .py extension.");
}

String pylo_tagname = "Pylo Install Path";
GetPersistentTagGroup().TagGroupSetTagAsString(pylo_tagname, install_path.PathExtractDirectory(0));