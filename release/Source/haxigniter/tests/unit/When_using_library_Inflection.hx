package haxigniter.tests.unit;

import haxigniter.common.libraries.Inflection;

class When_using_library_Inflection extends haxigniter.common.unit.TestCase
{
	public function test_Then_pluralize_should_follow_normal_english()
	{
		this.assertPlural('quizzes', 'quiz');
		this.assertPlural('aliases', 'alias');
		this.assertPlural('mice', 'mouse');
		this.assertPlural('tomatoes', 'tomato');
		this.assertPlural('buses', 'bus');
		this.assertPlural('shoes', 'shoe');
		this.assertPlural('thieves', 'thief');
		this.assertPlural('loudspeakers', 'loudspeaker');
		this.assertPlural('shelves', 'shelf');
		this.assertPlural('thieves', 'thief');
		this.assertPlural('ids', 'id');
		
		// Test for already plural
		this.assertPlural('tomatoes', 'tomatoes');
	}

	public function test_Then_singularize_should_follow_normal_english()
	{
		this.assertSingular('quiz', 'quizzes');
		this.assertSingular('alias', 'aliases');
		this.assertSingular('mouse', 'mice');
		this.assertSingular('tomato', 'tomatoes');
		this.assertSingular('bus', 'buses');
		this.assertSingular('shoe', 'shoes');
		this.assertSingular('thief', 'thieves');
		this.assertSingular('loudspeaker', 'loudspeakers');
		this.assertSingular('shelf', 'shelves');
		this.assertSingular('thief', 'thieves');
		this.assertSingular('id', 'ids');
		
		// Test for already singular
		this.assertSingular('rock', 'rock');
	}

	public function test_Then_some_words_are_not_inflected()
	{
		this.assertEqual('money', Inflection.pluralize('money'));
		this.assertEqual('money', Inflection.singularize('money'));
	}

	public function test_Then_some_words_are_irregularly_inflected()
	{
		this.assertEqual('geese', Inflection.pluralize('goose'));
		this.assertEqual('child', Inflection.singularize('children'));
	}

	public function test_Then_pluralizeIf_only_works_if_not_single_count()
	{
		this.assertEqual('stone', Inflection.pluralizeIf(1, 'stone'));
		this.assertEqual('stones', Inflection.pluralizeIf(0, 'stone'));
		this.assertEqual('stones', Inflection.pluralizeIf(500, 'stone'));
	}

	public function test_Then_singularizeIf_only_works_if_not_single_count()
	{
		this.assertEqual('moth', Inflection.singularizeIf(1, 'moths'));
		this.assertEqual('moths', Inflection.singularizeIf(0, 'moths'));
		this.assertEqual('moths', Inflection.singularizeIf(500, 'moths'));
	}

	public function assertPlural(plural : String, singular : String) : Void
	{
		this.assertEqual(plural, Inflection.pluralize(singular));
	}

	public function assertSingular(singular : String, plural : String) : Void
	{
		this.assertEqual(singular, Inflection.singularize(plural));
	}
}
