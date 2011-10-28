package mirror;

import neko.FileSystem;
import neko.io.File;

class Mirror
{
	private var sourceDir : String;
	private var destinationDir : String;

	public function new(sourceDir : String, destinationDir : String)
	{
		sourceDir = trimEndSlash(sourceDir);
		destinationDir = trimEndSlash(destinationDir);
		
		if(!FileSystem.exists(sourceDir) || !FileSystem.isDirectory(sourceDir))
			throw 'Error: Path "' + sourceDir + '" must exist and be a directory.';
		
		if(!FileSystem.exists(destinationDir) || !FileSystem.isDirectory(destinationDir))
			throw 'Error: Path "' + destinationDir + '" must exist and be a directory.';
		
		this.sourceDir = StringTools.replace(FileSystem.fullPath(sourceDir), '\\', '/');
		this.destinationDir = StringTools.replace(FileSystem.fullPath(destinationDir), '\\', '/');
	}
	
	private function delete(fileOrDir : String) : Void
	{
		if(FileSystem.isDirectory(fileOrDir))
			FileSystem.deleteDirectory(fileOrDir);
		else
			FileSystem.deleteFile(fileOrDir);
	}
	
	private function copy(source : String, dest : String) : Void
	{
		if(!FileSystem.isDirectory(source))
		{
			File.copy(source, dest);
		}
		else 
		{
			if(!FileSystem.exists(dest))
			{
				FileSystem.createDirectory(dest);
			}
			
			for(file in FileSystem.readDirectory(source))
				copy(source + '/' + file, dest + '/' + file);
		}		
	}
	
	public function mirror(?deleteNonExisting = false, ?ignorePaths : Array<String>, ?verbose = false) : Void
	{
		if(ignorePaths == null)
			ignorePaths = [];
		
		var self = this;
		if(deleteNonExisting)
		{
			loopDir(destinationDir, function(file : String) : Bool {
				var sourceFile = self.sourceDir + file.substr(self.destinationDir.length);
				var destFile = file;
				var relativeFile = file.substr(self.destinationDir.length + 1);

				if(!FileSystem.exists(sourceFile) && !Lambda.has(ignorePaths, relativeFile))
				{
					if(verbose) File.stdout().writeString('Deleting: ' + destFile + "\n");
					
					self.delete(destFile);
					return false;
				}
				else
					return true;
			});
		}
		
		loopDir(sourceDir, function(file : String) : Bool {
			var sourceFile = file;
			var destFile = self.destinationDir + file.substr(self.sourceDir.length);
			var relativeFile = file.substr(self.sourceDir.length + 1);
			
			if(Lambda.has(ignorePaths, relativeFile))
				return false;
			
			if(!FileSystem.exists(destFile) || FileSystem.stat(sourceFile).mtime.getTime() > FileSystem.stat(destFile).mtime.getTime())
			{
				if(verbose) File.stdout().writeString('Copying: ' + sourceFile + "\n");
				self.copy(sourceFile, destFile);
			}
			
			return true;
		});
	}

	/**
	 * Recursively loop through all files in a dir with a callback function.
	 * @param	dir Directory to loop through
	 * @param	callBack Each file and directory will be passed here (full path). If function returns false on a directory, it won't be looped through.
	 * @param	?recursive = true If false, no recursion will be done.
	 */
	public static function loopDir(dir : String, callBack : String -> Bool, ?recursive = true) : Void
	{
		Lambda.iter(FileSystem.readDirectory(dir), function(file : String) {
			file = dir + '/' + file;
			
			if(callBack(file) && recursive && FileSystem.isDirectory(file))
				loopDir(file, callBack, recursive);
		});
	}
	
	private function trimEndSlash(path : String) : String
	{
		if(StringTools.endsWith(path, '\\') || StringTools.endsWith(path, '/'))
			return path.substr(0, path.length - 1);
		else
			return path;
	}
}