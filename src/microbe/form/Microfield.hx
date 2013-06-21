package microbe.form;
//import microbe.vo.Spodable;
import microbe.form.IMicrotype;
class Microfield implements IMicrotype
{
	
	public var voId:Int;// pour microrecord  uniquement pour microrecord .. je l'ai rajouté aussi dans la generation de formulaire
	public var voName:String; //nom du vo sans le package
	public var field:String; //field in vo/sql
	public var element:String; //microbe.form.element
	public var elementId:String; //domId de l'element de formulaire microbe genéré
	public var value:String; //?opportun ? fait chier pour les dates
	public var type:InstanceType;
//	public var voRef:String; /// reference du champs au Vo"parent" sans le voPakage
	
	public function new()
	{
	
	}
	public function toString():String{
		
		#if (php )
		return "<div class='microfieldTrace'><p>MICROFIELD :<br/>type:"+type+"<br/>field:"+field+",<br/>voName:"+voName+",<br/>element:"+element+", <br/>elementId:"+elementId+"<br/>value:"+value+", <br/>voId:"+voId+"</p></div>";
		#end
		#if (flash || js)
		return "\nMICROFIELD :type:"+type+"\nfield:"+field+",\nvoName:"+voName+",\nelement:"+element+", \nelementId:"+elementId+"\nvalue:"+value +"\nvoId:"+voId;
		#end
		
		return "";
	}
}