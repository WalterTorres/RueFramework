RueFramework
============

This framework was made to make 2D game development quickly and efficiently, making use of OpenFL and Haxe for a rapid crossplatform development.


Example:
```java
import engine.base.EntityGroup;
import engine.World;
import flash.display.Sprite;

class Main extends Sprite 
{
	var TheWorld:World;
	
	public function new() 
	{
		super();	
		TheWorld = new World(this, 300, 768, EntryPoint);
	}
	
	private function EntryPoint(Group:EntityGroup):Void
	{
		//create your first entities here:
	}
}
```

--------------------------------------------------------------------------------

This framework is better used with its templates in FlashDevelop, you can find the templates for PooledItems, Entities, and Rue objects lists inside.

--------------------------------------------------------------------------------


This framework is open source under the MIT license.
