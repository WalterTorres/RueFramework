package engine.templates;
import engine.base.RueObject;
import engine.systems.MouseInputSystem;

/**
 * ...
 * @author Jakegr
 */

class MouseListener extends RueObject
{
	private var Connection:RueNodeConnection;
	
	private function new() 
	{
		super();
	}
	
	public function AddToMouseListener(Layer:Int):Void
	{
		Connection = MouseInputSystem.MouseListeners[Layer].Add(this);
	}
	
	public function RemoveFromMouseListener():Void
	{
		if (Connection != null)
		{
			Connection.Remove();
			Connection = null;
		}
	}
	
	public function CheckInput(X:Float, Y:Float):Bool
	{
		return false;
	}
	
	
}