package engine.templates;

import engine.base.Entity;
import engine.base.EntityGroup;
import engine.gameElements.interfaces.IDisplayView;
import engine.helpers.Profiler;
import engine.helpers.render.DrawStack;
import engine.systems.MouseInputSystem;
import engine.systems.SoundSystem;
import engine.components.PhysicsComponent;
import engine.components.GraphicsComponent;
import engine.World;
import nape.phys.BodyType;

/**
 * ...
 * @author Jakegr
 */

class RueViewController 
 extends Entity
{
	static var Head:RueViewController;
	var Next:RueViewController;
	var Self:RueViewController;
	
	var _TheView:IDisplayView;
	var _RenderTarget:DrawStack;
	public var _IsActivated:Bool;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(Group:EntityGroup, RenderTarget:DrawStack):RueViewController
	{
		var Vessel:RueViewController;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueViewController(); }
		Vessel.Setup(Group);
		Vessel._RenderTarget = RenderTarget;
		Vessel._IsActivated = true;
		
		return Vessel;
	}
	public static function CreateWithView(Group:EntityGroup, RenderTarget:DrawStack, View:IDisplayView):RueViewController
	{
		var Vessel:RueViewController;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueViewController(); }
		Vessel.Setup(Group);
		Vessel._TheView = View;
		Vessel._RenderTarget = RenderTarget;
		Vessel._IsActivated = true;
		return Vessel;
	}
	
	public function SetView(TheView:IDisplayView):Void
	{
		if (_TheView != null)
		{
			_TheView.Recycle(); //since the view we are replacing wont have anywhere to go, make sure you delete everything it contains in order to prevent memory leaks
		}
		
		_TheView = TheView;
	}
	
	private var UniqueDragging:IDisplayView;
	override public function PreUpdate():Void
	{
		if (!_IsActivated) { return; }
		if (_TheView != null)
		{
			_TheView.UpdateClickRec(0, 0);
			if (MouseInputSystem.Dragging)
			{
				if (UniqueDragging == null)
				{
					var TouchedView:IDisplayView = _TheView.CheckScreenInput(MouseInputSystem.X, MouseInputSystem.Y, 0, 0);
					if (TouchedView != null) //if something was indeed touched
					{
						if (TouchedView.IsScrollable())
						{
							TouchedView.StartDragging();
							UniqueDragging = TouchedView;
						}
					}
				}
				else
				{
					UniqueDragging.Dragging();
				}
			}
			else 
			{
				
				_TheView.CancelDrags();
				UniqueDragging = null;
			}
		}
	}
	
	public function FixClickRect():Void
	{
		_TheView.UpdateClickRec(0, 0);
	}
	
	override public function Update():Void
	{
		DoesUpdate = false;
	}
	
	override public function Draw():Void 
	{
		if (!_IsActivated) { return; }
		if (_TheView != null)
		{
			if (_RenderTarget != null)
			{
				_TheView.Render(0, 0, _RenderTarget);
			}
		}
	}
	
	override public function Recycle():Void
	{
		if (!InPool)
		{
			if (_TheView != null)
			{
				_TheView.Recycle();
				_TheView = null;
			}
			_RenderTarget = null;
			super.Recycle();
		}
		else
		{
			trace("recycled twice");
		}
	}
	
	override public function OnRebirth():Void 
	{
		Next = Head;
		Head = Self;
	}
		
	
}