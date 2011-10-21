package haxigniter.tests.unit;

import haxigniter.common.validation.FieldValidator;

class When_using_a_FieldValidator extends haxigniter.common.unit.TestCase
{
	private var v : FieldValidator;
	private var data : Dynamic;
	private var input : Dynamic;
	private var callbacks : Dynamic<ValidationCallback>;
	
	public override function setup()
	{
		data = {
			id: ~/^[1-9]\d*$/, 
			name: ~/^.{2,50}$/
		}
		
		input = { id: 123, name: "Boris" };
		
		callbacks = cast {};
		
		callbacks.id = function(input : Int) {
			return input == 123 ? input : null;
		}
		
		callbacks.name = function(input : String) {
			return input == 'Boris' ? input : null;
		}
	}
	
	public override function tearDown()
	{
	}
	
	public function test_Then_default_validation_should_pass_on_exact_match()
	{
		// Only regexps
		v = new FieldValidator(data);
		var result = v.validate(input);
		
		this.assertEqual(ValidationResult.success, result);
		
		// Only callbacks
		v = new FieldValidator(null, callbacks);
		var result = v.validate(input);
		
		this.assertEqual(ValidationResult.success, result);
	}

	public function test_Then_default_validation_should_fail_if_mismatch()
	{
		var failList = new List<String>();
		failList.add('id');
		
		// Only regexps
		v = new FieldValidator(data);
		var result = v.validate( { id: 000, name: "Boris" } );
		this.assertEqual(Std.string(ValidationResult.failure(failList)), Std.string(result));
		
		// Only callbacks
		v = new FieldValidator(null, callbacks);
		result = v.validate( { id: 000, name: "Boris" } );
		this.assertEqual(Std.string(ValidationResult.failure(failList)), Std.string(result));

		
		failList.add('name');
		
		#if php
		// Arguments come in reverse order in PHP
		failList.remove('id');
		failList.add('id');
		#end
		
		// Only regexps
		v = new FieldValidator(data);
		var result = v.validate( { id: 000, name: "X" } );
		this.assertEqual(Std.string(ValidationResult.failure(failList)), Std.string(result));
		
		// Only callbacks
		v = new FieldValidator(null, callbacks);
		result = v.validate( { id: 000, name: "X" } );
		this.assertEqual(Std.string(ValidationResult.failure(failList)), Std.string(result));
	}

	public function test_Then_default_validation_should_fail_on_too_few()
	{
		var failList = new List<String>();
		failList.add('id');

		// Regexps
		v = new FieldValidator(data);
		var result = v.validate( { name: "Boris" } );
		
		this.assertEqual(Std.string(ValidationResult.tooFew(failList)), Std.string(result));
		
		// Callbacks
		v = new FieldValidator(null, callbacks);
		var result = v.validate( { name: "Boris" } );
		
		this.assertEqual(Std.string(ValidationResult.tooFew(failList)), Std.string(result));
	}
	
	/////////////////////////////////////////////////////////////////
	
	public function test_Then_validation_should_not_fail_on_too_few_if_specified()
	{
		v = new FieldValidator(data, null, ValidationType.allowTooFew);
		var result = v.validate( { name: "Boris" } );
		
		this.assertEqual(ValidationResult.success, result);
		
		v = new FieldValidator(null, callbacks, ValidationType.allowTooFew);
		var result = v.validate( { name: "Boris" } );
		
		this.assertEqual(ValidationResult.success, result);
	}
	
	public function test_Then_validation_should_always_fail_on_too_many()
	{
		var input = { name: "Boris", id: 123, extra: "Data" };
		var failList = new List<String>();
		failList.add('extra');


		v = new FieldValidator(data);
		var result = v.validate(input);		
		this.assertEqual(Std.string(ValidationResult.tooMany(failList)), Std.string(result));

		v = new FieldValidator(null, callbacks);
		var result = v.validate(input);
		this.assertEqual(Std.string(ValidationResult.tooMany(failList)), Std.string(result));

		
		v = new FieldValidator(data, null, ValidationType.allowTooFew);
		result = v.validate(input);		
		this.assertEqual(Std.string(ValidationResult.tooMany(failList)), Std.string(result));
		
		v = new FieldValidator(null, callbacks, ValidationType.allowTooFew);
		result = v.validate(input);
		this.assertEqual(Std.string(ValidationResult.tooMany(failList)), Std.string(result));
	}
	
	/////////////////////////////////////////////////////////////////
	
	public function test_Then_validation_with_mixed_callbacks_and_regexps_should_succeed()
	{
		data = { id: ~/^[1-9]\d*$/ }
		
		callbacks = cast {};		
		callbacks.name = function(input : String) {
			return input;
		}

		v = new FieldValidator(data, callbacks);
		var result = v.validate(input);		
		this.assertEqual(ValidationResult.success, result);		
	}
	
	public function test_Then_validation_with_mixed_callbacks_and_regexps_should_fail_on_too_few_and_many()
	{
		var failList = new List<String>();
		failList.add('name');

		data = { id: ~/^[1-9]\d*$/ }
		
		callbacks = cast {};		
		callbacks.name = function(input : String) {
			return input;
		}

		v = new FieldValidator(data, callbacks);
		
		var result = v.validate({ id: 123 });
		this.assertEqual(Std.string(ValidationResult.tooFew(failList)), Std.string(result));

		failList = new List<String>();
		failList.add('extra');
		
		result = v.validate({ id: 123, extra: 'Doris' });
		this.assertEqual(Std.string(ValidationResult.tooMany(failList)), Std.string(result));
		
		result = v.validate({ id: 123, name: 'Boris' });
		this.assertEqual(ValidationResult.success, result);
	}

	public function test_Then_callbacks_will_fail_the_test_when_returning_null()
	{
		callbacks = cast {};
		callbacks.name = function(input : String) {
			return null;
		}

		var data = { name: 'Boris' };
		
		v = new FieldValidator(null, callbacks);
		
		this.assertEqual(Std.string(ValidationResult.failure(Lambda.list(['name']))), Std.string(v.validate(data)));
	}

	public function test_Then_callbacks_can_alter_the_input_by_returning_the_new_value()
	{
		callbacks = cast {};
		callbacks.name = function(input : String) {
			return 'Doris';
		}

		var data = { name: 'Boris' };
		
		v = new FieldValidator(null, callbacks);
		
		this.assertEqual(ValidationResult.success, v.validate(data));
		this.assertEqual('Doris', data.name);
	}

	/////////////////////////////////////////////////////////////////
	
	public function test_Then_fieldValidation_should_succeed_on_correct_value()
	{
		v = new FieldValidator(data);
		
		this.assertTrue(v.validateField('id', 123));		
		this.assertFalse(v.validateField('id', 'Boris'));
		this.assertTrue(v.validateField('name', 'Boris'));
		
		try
		{
			v.validateField('extra', 'whatever');
		}
		catch(e : String)
		{
			this.assertEqual('Field "extra" not found in FieldValidator.', e);
		}
		
		try
		{
			v.validateField('id', {bla: 'BLA'});
		}
		catch(e : String)
		{
			this.assertEqual('Field "id" is not a scalar value.', e);
		}
	}
}