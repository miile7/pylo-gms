String pylo_install_path;
String pylo_main_file_path;
String pylo_main_file_name = "start.py";

String pylo_tagname = "Pylo Install Path";
GetPersistentTagGroup().TagGroupGetTagAsString(pylo_tagname, pylo_install_path);

if(pylo_install_path == ""){
	throw("The pylo installation path is empty.");
}
else if(pylo_main_file_path == ""){
	pylo_main_file_path = pylo_install_path.PathConcatenate(pylo_main_file_name);
}

if(!pylo_install_path.DoesDirectoryExist()){
	throw("The pylo installation path '" + pylo_install_path + "' does not exist.");
}
else if(!pylo_main_file_path.DoesFileExist()){
	throw("The pylo executable file '" + pylo_main_file_path + "' does not exist.");
}
else if(pylo_main_file_path.PathExtractExtension(0) != "py"){
	throw("The pylo executable file '" + pylo_main_file_path + "' is not a python file.");
}

GetPersistentTagGroup().TagGroupSetTagAsString(pylo_tagname, pylo_install_path);

number encoding = 0; // current encoding
number file_reference = OpenFileForReading(pylo_main_file_path);

object file_stream = NewStreamFromFileReference(file_reference, 0);
file_stream.StreamSetPos(0, 0);
string content = file_stream.StreamReadAsText(encoding, file_stream.StreamGetSize());

CloseFile(file_reference);

content = "__file__ = r\"" + pylo_main_file_path + "\"\n\n" + content

ExecutePythonScriptString(content);