package microbe.backof;

typedef NavItem =
{
	label:String,
	data:Int,
	vo:String
}
//a overrider biensùr...
class Navigation
{
	public var items:List<NavItem>;
	public function new() 
	{
	//	items= [{label:"presentation",data:1,vo:"Carousel"},{label:"user",data:3,vo:"UserVo"},{label:"proprietaire",data:4,vo:"ProprietaireVo"},{label:"contact",data:5,vo:"Contact"},{label:"catalogue",data:6,vo:"Catalogue"},{label:"blog",data:7,vo:"Blog"}];
	items= new List<NavItem>();
	items.add({label:"edito",data:1,vo:"New"});
	}
}

