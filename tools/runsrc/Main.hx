import neko.Lib;
import neko.Sys;
import neko.io.File;
import neko.FileSystem;

import mirror.Mirror;
import getpot.GetPot;

using StringTools;
class Main 
{
	static var commands : Array<String>;
	static var libPath : String;
	static var debugMode : Bool;
	
	static var validCommands = [
		'build',
		'help', 
		'init',
		'nekoserver',
		'unittest'
		];
		
	static var validCommandsHelp = [
		'Build the project.',
		'Display this help text.',
		'Create a project structure in a directory.',
		'Start the Neko web server for testing.',
		'Run the haXigniter unit test suite.'
		];
	
	static function main() 
	{
		var args = Sys.args();
		libPath = libraryPath();

		// haxelib sets the current directory to the library path and puts the
		// real current directory in the args, so if they are the same, it's
		// not using a local version of run.n.
		if(libPath != null && Sys.getCwd().replace('\\', '/') == libPath.replace('\\', '/'))
		{
			Sys.setCwd(args.pop());
			debugMode = false;
		}
		else
		{
			libPath = neko.io.Path.directory(neko.FileSystem.fullPath(neko.vm.Module.local().name)) + '/';
			debugMode = true;
		}
		
		var command = args[0];
		if(command == null || Lambda.has(['--help', '-help', '-?', '/?'], command))
		{
			Sys.exit(helpCommands());
		}
		else if(!Lambda.has(validCommands, command))
		{
			Lib.println('Command not found: ' + command);
			Lib.println('');
			
			Sys.exit(helpCommands());
		}
		else
		{
			commands = args.slice(1);			
			Sys.exit(Reflect.field(Main, command)(new GetPot(commands)));
		}
	}
	
	static function stringRepeat(input : String, count : Int) : String
	{
		var buffer = new StringBuf();
		while(count-- > 0)
			buffer.add(input);
		
		return buffer.toString();
	}

	static function error(message : String) : Int
	{
		Lib.println('Error: ' + message);
		return 1;		
	}
	
	///// Commands //////////////////////////////////////////////////

	private static function helpCommands() : Int
	{
		var tabLength = Lambda.fold(validCommands, function(cmd : String, length : Int) {
			return cast(Math.max(length, cmd.length), Int);
		}, 0);
		
		Lib.println('Valid commands are:');
		
		for(i in 0 ... validCommands.length)
		{
			Lib.println('  ' + validCommands[i] + stringRepeat(' ', tabLength - validCommands[i].length + 5) + validCommandsHelp[i]);
		}
		
		Lib.println('');
		Lib.println('Use "help COMMAND" for help about a specific command.');
		
		return 1;
	}
	
	static function help(options : GetPot) : Int
	{
		var command = options.unprocessed();
		var help : String = null;

		switch(command)
		{
			case null:
				return helpCommands();
				
			case 'build':
				help = 'build [buildfile.hxml] [compiler options ...]

  This command compiles the project, after running the "prebuild" command.
  If a .hxml file isn\'t specified, the first one found in the directory 
  will be used. All arguments after the buildfile will be passed on to the 
  haxe compiler.';

			case 'init':
				help = 'init [path] [-neko]
				
  Creates a project structure for a haXigniter project in a directory. If
  no dir is specified, it will be prompted for. The -neko switch can be 
  used to create the project .hxml file for Neko instead of the default 
  PHP.';

			case 'help':
				help = '  "He has a right to criticize, who has a heart to help."
  -- Abraham Lincoln';
  
			case 'nekoserver':
				help = 'nekoserver [-p port] [-h host] [-d documentroot]

  Starts a neko web server for immediate testing of the project (if it\'s
  built for Neko). If no port and/or host is specified, the default is 
  port 2001 and localhost. If no documentroot is specified, it will be 
  read from the project .hxml file.
  
  The "-rewrite" switch is implicit for this command since the nekoserver
  doesn\'t handle the haXigniter URL\'s without it.';

  			case 'unittest':
				help = 'unittest
				
  Executes the haXigniter unit tests. For developers only, or if you want
  to make sure your changes didn\'t break anything in the library.';

			default:
				help = 'No help is available on this command, sorry.';
		}
		
		Lib.println("\n" + help);
		return 1;
	}
	
	static function build(options : GetPot) : Int
	{
		var buildFile = options.unprocessed();
		if(buildFile == null || !StringTools.endsWith(buildFile, '.hxml'))
		{
			buildFile = firstBuildFile('.');
			if(buildFile == null)
				return error('No .hxml file found in current directory!');
			
			// Append the buildfile to commands so haxe can use it.
			commands.unshift(buildFile);
		}
		else if(!FileSystem.exists(buildFile))
		{
			return error(buildFile + ' not found!');
		}
		
		var outputPath : String = buildPathFromHxml(buildFile);
		if(outputPath == null)
			return error('No output directory found in .hxml file!');
		
		Lib.println('Building project in ' + FileSystem.fullPath(outputPath));
		
		return Sys.command('haxe', commands);
	}
	
	static function nekoserver(options : GetPot) : Int
	{
		//nekoserver [-p port] [-h host] [-d documentroot]
		var args : Array<String> = ['server'];
		
		args.push('-p');
		args.push(options.follow('2001', ['-p']));
		
		args.push('-h');
		args.push(options.follow('localhost', ['-h']));
		
		args.push('-d');
		if(options.got(['-d']))
			args.push(options.next());
		else
		{
			var buildFile = firstBuildFile('.');
			if(buildFile == null)
				return error('No .hxml file found in current directory!');
			
			var outputPath : String = buildPathFromHxml(buildFile);
			if(outputPath == null)
				return error('No output directory found in .hxml file!');
			
			args.push(outputPath);
		}
		
		args.push('-rewrite');
		
		Lib.println('Browse to http://' + args[4] + ':' + args[2] + '/ for testing.');
		Lib.println('Press Ctrl+C to stop server.');
		
		return Sys.command('nekotools', args);
	}

	static function init(options : GetPot) : Int
	{
		var nekoMode = options.got(['-neko']);
		
		var path = options.unprocessed();
		if(path == null)
		{
			Lib.print('Select directory to create haXigniter project in (blank = current dir, Ctrl+C to exit): ');

			try
			{
				path = File.stdin().readUntil(10);
			}
			catch(e : Dynamic)
			{
				return 1;
			}
			
			if(path.length == 0)
				path = '.';
		}
		
		if(!FileSystem.exists(path))
		{
			FileSystem.createDirectory(path);
		}
		else if(!FileSystem.isDirectory(path))
		{
			return error(path + '" is not a directory.');
		}
		
		path = FileSystem.fullPath(path);
		
		Lib.println('Copying project structure to ' + path);

		var dirs = new Mirror(libPath + 'squelette', path);
		dirs.mirror();
		
		
		if(nekoMode)
		{
			// Rewrite the hxml file if -neko was passed.
			var hxmlFile = path + '/myapp.hxml';
			var hxml = File.getContent(hxmlFile).replace("\n-php www", "\n-neko www/index.n");
			putContent(hxmlFile, hxml);
			
			// Rewrite the hxproj file too.
			var hxprojFile = path + '/myapp.hxproj';
			var hxproj = File.getContent(hxprojFile);
			
			hxproj = hxproj.replace('<movie path="www" />', '<movie path="www\\index.n" />');
			hxproj = hxproj.replace('<movie version="13" />', '<movie version="12" />');
			
			putContent(hxprojFile, hxproj);
			
			// Rewrite the mod_rewrite file.
			var modRewrite = path + '/doc/mod_rewrite.conf';
			var content = File.getContent(modRewrite).replace("index.php/$1", "index.n/$1");
			putContent(modRewrite, content);
		}
		
		/*
		// Purge all empty .gitignore files.
		mirror.Mirror.loopDir(path, function(filename : String) {
			if(filename.endsWith('.gitignore') && FileSystem.stat(filename).size == 0)
			{
				FileSystem.deleteFile(filename);
				return false;
			}
			else
				return true;
		});
		*/

		Lib.println('Finished. To build the project, goto ' + path + ' and enter "ignite build".');
		return 0;
	}

	static function unittest(options : GetPot) : Int
	{
		var oldPath = Sys.getCwd();
		var path = libPath + 'tools/runsrc';
		
		var args = ['-main', 'RunUnitTests', '-x', 'rununittests'];

		if(!debugMode)
		{
			args = ['-lib', 'haxigniter'].concat(args);
		}
		else
		{
			// If debugging, use the local libPath as source.
			args = ['-cp', libPath].concat(args);
		}
		
		Lib.println('Executing haXigniter tests...');

		Sys.setCwd(path);
		
		var status = Sys.command('haxe', args);
		
		if(FileSystem.exists('rununittests.n'))
			FileSystem.deleteFile('rununittests.n');
		
		Sys.setCwd(oldPath);
			
		return status;
	}
	
	/////////////////////////////////////////////////////////////////
	
	private static function firstBuildFile(buildDir : String) : String
	{
		for(file in FileSystem.readDirectory(buildDir))
		{
			if(file.endsWith('.hxml'))
				return FileSystem.fullPath(buildDir + '/' + file);
		}
		
		return null;
	}
	
	private static function buildPathFromHxml(buildFile : String) : String
	{
		var content = File.getContent(buildFile);
		
		// Filter out comments so they don't get caught in the regexp.
		var commentFilter = ~/#.*/g;
		content = commentFilter.replace(content, '');
		
		var phpTest = ~/-php\s+(.+)\b/;
		var nekoTest = ~/-neko\s+(.+)[\/]\b/;
		
		if(phpTest.match(content))
			return parseArgument(phpTest.matched(1));
		else if(nekoTest.match(content))
			return parseArgument(nekoTest.matched(1));
		else
			return null;
	}
	
	private static function createHtaccess(path : String, force = false) : Void
	{
		var htaccess = path + '/.htaccess';
		
		if(force || !FileSystem.exists(htaccess))
		{
			putContent(htaccess, "order deny,allow\ndeny from all\nallow from none\n");
		}		
	}
	
	private static function putContent(filename : String, content : String) : Void
	{
		var file = File.write(filename, true);
		file.writeString(content);
		file.close();
	}
	
	private static function createIfNotExists(path : String) : Void
	{
		if(!FileSystem.exists(path))
			FileSystem.createDirectory(path);
	}
	
	/**
	 * Parses the first argument in a long string. 
	 * "quoted argument with spaces" or noSpaces/atAll for example.
	 * @param	input
	 * @return
	 */
	private static function parseArgument(input : String) : String
	{
		if(!input.startsWith('"') && !input.startsWith("'"))
		{
			var string = ~/^\S+/;
			string.match(input);
			
			return string.matched(0);
		}

		var output = '';
		for(i in 1 ... input.length)
		{
			var char = input.charAt(i);
			
			if(char == '"' || char == "'")
				return output;
			else
				output += char;
		}
		
		return output;
	}	
	
	private static function libraryPath() : String
	{
		// Get path to the haxigniter library.
		var process = new neko.io.Process('haxelib', ['path', 'haxigniter']);
		var libPath = process.stdout.readUntil(10).trim();
		process.close();
		
		if(new EReg('not installed', '').match(libPath))
			libPath = null;
		
		return libPath;
	}
}