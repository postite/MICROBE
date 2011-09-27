package microbe.form;
//import microbe.vo.Spodable;
import microbe.form.IMicrotype;
class Microfield implements IMicrotype
{
	
	public var voName:String; //nom du vo sans le package
	public var field:String; //field in vo/sql
	public var element:String; //microbe.form.element
	public var elementId:String; //domId de l'element de formulaire microbe genéré
	public var value:String; //?opportun ?
	public var type:InstanceType;
//	public var voRef:String; /// reference du champs au Vo"parent" sans le voPakage
	
	public function new()
	{
	
	}
	public function toString():String{
		#if (php || js)
		return "<div class='microfieldTrace'><p>MICROFIELD :<br/>type:"+type+"<br/>field:"+field+",<br/>voName:"+voName+",<br/>element:"+element+", <br/>elementId:"+elementId+"<br/>value:"+value+"</p></div>";
		#end
		#if flash
		return "\nMICROFIELD :type:"+type+"\nfield:"+field+",\nvoName:"+voName+",\nelement:"+element+", \nelementId:"+elementId+"\nvalue:"+value +"\n";
		#end
		
		return "";
	}
}