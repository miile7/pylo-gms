// = = = find pylo install path = = =
String pylo_install_path;

// use path from tags
String pylo_tagname = "Pylo Install Path";
if(!GetPersistentTagGroup().TagGroupGetTagAsString(pylo_tagname, pylo_install_path)){
    pylo_install_path = "";
}

string python_code = "";

if(pylo_install_path != "" && pylo_install_path.DoesDirectoryExist()){
	// remove trailing backslash
	if(pylo_install_path.right(1) == "\\"){
		pylo_install_path = pylo_install_path.left(pylo_install_path.len() - 1);
	}
	
    // for manual installation only
    python_code += "import os\n";
    python_code += "import sys\n";
    python_code += "p = os.path.normpath(os.path.dirname(r\"" + pylo_install_path + "\"))\n";
    python_code += "if p not in sys.path:\n";
    python_code += "    sys.path.append(p)\n";
    python_code += "\n";
}

// = = = show settings = = = 

python_code += "import pylo\n";
python_code += "\n";
python_code += "view = pylo.DMView()\n";
python_code += "configuration = pylo.DMConfiguration()\n";
python_code += "pylo.pylolib.defineConfigurationOptions(configuration)\n";
python_code += "\n";
python_code += "try:\n";
python_code += "    settings = view.showSettings(configuration)\n";
python_code += "    if isinstance(settings, dict):\n";
python_code += "        configuration.loadFromMapping(settings)\n";
python_code += "        configuration.saveConfiguration()\n";
python_code += "except pylo.StopProgram:\n";
python_code += "    pass\n";

ExecutePythonScriptString(python_code);