package engine.templates;

import engine.base.Entity;
import engine.base.EntityGroup;
import engine.helpers.Profiler;
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
	
	public var _TheView:RueView;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(Group:EntityGroup):RueViewController
	{
		var Vessel:RueViewController;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueViewController(); }
		Vessel.Setup(Group);
		
		return Vessel;
	}
	public static function CreateWithView(Group:EntityGroup, View:RueView):RueViewController
	{
		var Vessel:RueViewController;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueViewController(); }
		Vessel.Setup(Group);
		Vessel._TheView = View;
		return Vessel;
	}
	private var UniqueDragging:RueView;
	override public function PreUpdate():Void
	{
		if (_TheView != null)
		{
			if (MouseInputSystem.Clicked)
			{
				_TheView.CancelDrags();//in case something was being dragged
				var TouchedView:RueView = _TheView.CheckScreenInput(MouseInputSystem.X, MouseInputSystem.Y, 0, 0);
				if (TouchedView != null) //if something was indeed touched
				{
					TouchedView._OnClick.TriggerAll();
				}
			}
			else if (MouseInputSystem.Dragging)
			{
				if (UniqueDragging == null)
				{
					var TouchedView:RueView = _TheView.CheckScreenInput(MouseInputSystem.X, MouseInputSystem.Y, 0, 0);
					if (TouchedView != null) //if something was indeed touched
					{
						if (TouchedView._IsScrollable)
						{
							if (TouchedView._IsDragging)
							{
								TouchedView.Dragging();
							}
							else
							{
								TouchedView.StartDragging();
								UniqueDragging = TouchedView;
							}
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
	
	override public function Update():Void
	{
		
	}
	
	override public function Draw():Void 
	{
		if (_TheView != null)
		{
			_TheView.Render(0,0);
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
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void 
	{
		Next = Head;
		Head = Self;
	}
		
	
}