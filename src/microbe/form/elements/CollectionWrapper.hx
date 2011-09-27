package microbe.form.elements;
import microbe.form.FormElement;
import microbe.form.elements.CollectionElement;
class CollectionWrapper extends FormElement
{
	var wrapped:List<FormElement>;
	public function new()
	{
		
		super();
		wrapped=new List<FormElement>();
	}
	override function render(?iter:Int) : String {
			var str:String="<div class='collectionWrapper'>";
			for(item in wrapped){
				str+=item.render();
			//	str+=item.render(2);
			}
			str+="</div>";
			return str;
	}
	
	public function addElement(collecItem:FormElement) : Void {
		collecItem.form=this.form;
		wrapped.add(collecItem);
	}
	public function removeElement(collecItem:FormElement) : Void {
		wrapped.remove(collecItem);
	}
	
}
