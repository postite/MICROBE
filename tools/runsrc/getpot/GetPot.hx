// Copyright (c) 2009, Jens Peter Secher <jpsecher@gmail.com>
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

//
// Inspired by Frank-Rene Schaefer GetPot (see
// http://getpot.sourceforge.net/GetPot.html).
//

package getpot;

class GetPot
{
	//
	// Call with eg. neko.Sys.args() as argument.
	//
	public function new( args : Array<String> )
	{
		arguments = new List<List<String>>();
		// The sequence is filled up with collected arguments.
		var sequence = new List<String>();
		for( arg in args )
		{
			var option = ~/^-/;
			if( option.match( arg ) )
			{
				// If the collected sequence is not empty when the next argument
				// is an option, the sequence will have to be flushed and
				// restarted.
				if( sequence.length != 0 )
				{
					arguments.add( sequence );
					sequence = new List<String>();					
				}
				sequence.add( arg );				
			}
			else
			{
				sequence.add( arg ); 
			}
		}
		if( sequence.length != 0 )
		{
			arguments.add( sequence );
		}
		// Make sure next() will return null.
		nextArg = null;
	}

	//
	// Takes an array of options (eg. ["-C","--check"]) to search for in the
	// command line, and returns true if any of those options were found.  The
	// first such option found is removed from the command line and the next()
	// function can then be used to collect following non-option arguments, if
	// any.
	//
	public function got( options : Array<String> ) : Bool
	{
		cleanup();
		for( sequence in arguments )
		{
			var first = sequence.first();
			if( first != null )
			{
				for( option in options )
				{
					if( option == first )
					{
						// Remove the arguments because is has now been processed.
						sequence.pop();
						// Make sure next() will get the next arguments.
						nextArg = sequence;
						return true;
					}
				}
			}
		}
		return false;
	}
		
	//
	// Returns the next argument following the last got() option and removes
	// that argument from the command line.  Returns null if there are no more.
	//
	public function next() : Null<String>
	{
		if( nextArg == null ) return null;
		return nextArg.pop();
	}

	public function follow(defaultValue : String, options : Array<String>) : String
	{
		return got(options) ? next() : defaultValue;
	}

	//
	// Returns the first option which has not been got() and removes the option
	// from the command line.  Returns null if there are no more options.
	//
	public function unknown() : Null<String>
	{
		cleanup();
		for( sequence in arguments )
		{
			if( sequence.first() != null )
			{
				var option = ~/^-/;
				if( option.match( sequence.first() ) )
				{
					return sequence.pop();
				}
			}
		}
		return null;
	}
		
	//
	// Returns the first arguments which has not processed yet and removes the
	// it from the command line.  Returns null if there are no more unprocessed
	// arguments.  This function should only be called after unknown() has
	// returned null to ensure that all options have been precessed.
	//
	public function unprocessed() : Null<String>
	{
		cleanup();
		for( sequence in arguments )
		{
			if( sequence.first() != null )
			{
				return sequence.pop();
			}
		}
		return null;
	}

	//
	// Remove all initial empty sequences.
	//
	function cleanup()
	{
		while( arguments.first() != null && arguments.first().first() == null )
		{
			arguments.pop();
		}
	}

	//
	// Each sequence of successive arguments.  All options will be the first
	// element in one of the sequences.  Whenever an arguments has been
	// processed, it is removed from its sequences.
	//
	var arguments : List<List<String>>;
	
	//
	// Points to the sequence of arguments following the last got() option, or
	// null if no got() has succeeded.
	//
	var nextArg : List<String>;
}
