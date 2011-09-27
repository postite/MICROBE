package ;
import microbe.backof.Navigation;

class Nav extends Navigation
{
	public function new()
	{
	super();
	
	items=new List<NavItem>();
	
	var a:NavItem=cast {};
	a.data=1;
	a.label="news";
	a.vo="News";
	
	var b:NavItem=cast {};
	b.data=2;
	b.label="edito";
	b.vo="Edito";
	
	items.add(a);
	items.add(b);
	
	}
}