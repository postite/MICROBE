package microbe;
import microbe.form.IMicrotype;
import microbe.factoryType.CollectionBehaviour;
import microbe.factoryType.FormElementBehaviour;
import microbe.factoryType.SpodableBehaviour;
import microbe.factoryType.IBehaviour;

class TypeFactory
{
	public function new()
	{
		
		
	}
	public function create(type:InstanceType):IBehaviour{
		switch ( type )
		{
			case InstanceType.spodable:
			return Type.createInstance(SpodableBehaviour,[]);
			case InstanceType.formElement:
			return Type.createInstance(FormElementBehaviour,[]);
			case InstanceType.collection:
			return Type.createInstance(CollectionBehaviour,[]);
		}
	}
}