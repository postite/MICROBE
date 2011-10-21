package microbe.form;


class BrickField
{
	public var voName:String; // le nom du Vo à updater sur ce Brick
	public var field:String;// le champs reference dans la base
	public var enfants:List<BrickField>; //une liste de brickFields == arborescence //chiant à gerer le plusieur
	public var element:FormElement; //composant Microbe.formElement
	public var id:String; //DomId
	public var voRel:String; // if relation le vo relatif
	public var relation:String; //if relation 
	public var valeur:String; // valeur à enregistrer et à parser
//	public var value:Dynamic; //surement String
	
	public function new()
	{
		
	}
	public function toString():String{
		var str= "voName:"+voName;
		str+="<br/>";
		str+="field:"+field;
		str+="<br/>";
	/*		str+="<br/>";
			str+="----enfants:"+enfants;
				str+="<br/>";
			str+="id:"+id;
				str+="<br/>";
			str+="voRel:"+voRel;
				str+="<br/>";
			str+="relation:"+relation;
				str+="<br/>";
			str+="valeur:"+valeur;*/
		return str;
	}
}