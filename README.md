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
		TheWorld.start(); //this hooks up the world game loop and calls your entry point with the main entity group.
	}
	
	private function EntryPoint(Group:EntityGroup):Void
	{
		//create your first entities here:
	}
}
```

--------------------------------------------------------------------------------

RueView
-------

One of the features of the Rueframework is the use of Views for creating UI, RueViews operate similarly to the Apple views, they can be linked in a parent child relationship and all of them can be extended for your own custom implementations.

Here is a video showing how views behave: http://www.youtube.com/watch?v=70qyn3LGL8g&feature=youtu.be

As of right now the framework is under development, which will make the usage of views fluctuate (until I make them as user friendly as possible).

For more information on views check the ViewManipulator class.

--------------------------------------------------------------------------------

This framework is better used with its templates in FlashDevelop, you can find the templates for PooledItems, Entities, and Rue objects lists inside.

--------------------------------------------------------------------------------


This framework is open source under the MIT license.
