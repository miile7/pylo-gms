// let the user confirm the reset
if(!TwoButtonDialog("Are you sure that you want to reset the settings? All settings are lost.", "Yes", "No")){
    exit(0);
}

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

// = = = reset configuration = = = 

python_code += "import pylo\n";
python_code += "\n";
python_code += "configuration = pylo.DMConfiguration()\n";
python_code += "\n";
python_code += "configuration.reset()\n";

ExecutePythonScriptString(python_code);

OkDialog("Settings are reset");