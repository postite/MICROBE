package haxigniter.common.libraries;

/**
 * Many thanks to http://kuwamoto.org/2007/12/17/improved-pluralizing-in-php-actionscript-and-ror/
 * The Inflection library is licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */
class Inflection
{
    private static var toPluralRegexps : Array<EReg> = [
        ~/(quiz)$/i,
        ~/^(ox)$/i,
        ~/([m|l])ouse$/i,
        ~/(matr|vert|ind)ix|ex$/i,
        ~/(x|ch|ss|sh)$/i,
        ~/([^aeiouy]|qu)y$/i,
        ~/(hive)$/i,
        ~/([^f])fe$/i,
		~/([lr])f$/i,
        ~/(shea|lea|loa|thie)f$/i,
        ~/sis$/i,
        ~/([ti])um$/i,
        ~/(tomat|potat|ech|her|vet)o$/i,
        ~/(bu)s$/i,
        ~/(alias|status)$/i,
        ~/(octop)us$/i,
        ~/(ax|test)is$/i,
        ~/(us)$/i,
        ~/s$/i,
        ~/$/i,
    ];
    
    private static var toPluralReplacements : Array<String> = [
        "$1zes",
        "$1en",
        "$1ice",
        "$1ices",
        "$1es",
        "$1ies",
        "$1s",
        "$1ves",
		"$1ves",
        "$1ves",
        "ses",
        "$1a",
        "$1oes",
        "$1ses",
        "$1es",
        "$1i",
        "$1es",
        "$1es",
        "s",
        "s"
    ];
    
    private static var toSingularRegexps : Array<EReg> = [
        ~/(quiz)zes$/i,
        ~/(matr)ices$/i,
        ~/(vert|ind)ices$/i,
        ~/^(ox)en$/i,
        ~/(alias|status)es$/i,
        ~/(octop|vir)i$/i,
        ~/(cris|ax|test)es$/i,
        ~/(shoe)s$/i,
        ~/([o])es$/i, // square brackets are required, otherwise PHP regexp fails!
        ~/(bus)es$/i,
        ~/([m|l])ice$/i,
        ~/(x|ch|ss|sh)es$/i,
        ~/(m)ovies$/i,
        ~/(s)eries$/i,
        ~/([^aeiouy]|qu)ies$/i,
        ~/([lr])ves$/i,
        ~/(tive)s$/i,
        ~/(hive)s$/i,
        ~/(li|wi|kni)ves$/i,
        ~/(shea|loa|lea|thie)ves$/i,
        ~/(^analy)ses$/i,
        ~/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/i,
        ~/([ti])a$/i,
        ~/([n])ews$/i, // square brackets are required, otherwise PHP regexp fails!
        ~/(h|bl)ouses$/i,
        ~/(corpse)s$/i,
        ~/(us)es$/i,
        ~/s$/i,
    ];
    
    private static var toSingularReplacements : Array<String> = [
        "$1",
        "$1ix",
        "$1ex",
        "$1",
        "$1",
        "$1us",
        "$1is",
        "$1",
        "$1",
        "$1",
        "$1ouse",
        "$1",
        "$1ovie",
        "$1eries",
        "$1y",
        "$1f",
        "$1",
        "$1",
        "$1fe",
        "$1f",
        "$1sis",
        "$1$2sis",
        "$1um",
        "$1ews",
        "$1ouse",
        "$1",
        "$1",
        ""
    ];

	private static var irregularSingular : Array<String> = [
		'move',
		'foot',
		'goose',
		'sex',
		'child',
		'man',
		'tooth',
		'person'
	];

	private static var irregularPlural : Array<String> = [
		'moves',
		'feet',
		'geese',
		'sexes',
		'children',
		'men',
		'teeth',
		'people'
	];
    
    private static var uncountable : Array<String> = [
        'sheep',
        'fish',
        'deer',
        'series',
        'species',
        'money',
        'rice',
        'information',
        'equipment'
    ];

	private static function processInflection(string : String, irregularFrom : Array<String>, irregularTo : Array<String>, regexps : Array<EReg>, replacements : Array<String>) : String
    {
		var lowerString = string.toLowerCase();
        
		// save some time in the case that singular and plural are the same
		if(Lambda.exists(uncountable, function(uncountableWord) { return lowerString == uncountableWord; }))
          return string;
		  
        // check for irregular forms
		for(i in 0 ... irregularFrom.length)
		{
            var pattern = new EReg(irregularFrom[i] + "$", "i");
            var replacement = irregularTo[i];

            if (pattern.match(string))
                return pattern.replace(string, replacement);
		}

		// check for matches using regular expressions
        for(i in 0 ... regexps.length)
        {
            var pattern = regexps[i];
            var replacement = replacements[i];
			
            if(pattern.match(string))
			{
				return pattern.replace(string, replacement);
			}
        }
		
        return string;
    }
	
    public static function pluralize( string : String ) : String
    {
		return processInflection(string, irregularSingular, irregularPlural, toPluralRegexps, toPluralReplacements);
    }
	
    public static function singularize( string : String ) : String
    {
		return processInflection(string, irregularPlural, irregularSingular, toSingularRegexps, toSingularReplacements);
    }
	
    public static function pluralizeIf(count : Int, string : String) : String
    {
		return count == 1 ? string : pluralize(string);
    }

	public static function singularizeIf(count : Int, string : String) : String
    {
		return count == 1 ? singularize(string) : string;
    }
}
