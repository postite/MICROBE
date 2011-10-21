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
	
	var c:NavItem=cast {};
	c.data=3;
	c.label="relationTest";
	c.vo="RelationTest";
	
	items.add(a);
	items.add(b);
	items.add(c);
	
	}
}