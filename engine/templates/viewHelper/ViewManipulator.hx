package engine.templates.viewHelper;

import engine.base.Entity;
import engine.base.EntityGroup;
import engine.base.RueObject.RueNodeConnection;
import engine.helpers.Profiler;
import engine.systems.MouseInputSystem;
import engine.systems.SoundSystem;
import engine.components.PhysicsComponent;
import engine.components.GraphicsComponent;
import engine.templates.collections.RueCallback;
import engine.templates.collections.RueCallbackList;
import engine.templates.RueView;
import engine.templates.viewHelper.steps.AlphaStep;
import engine.templates.viewHelper.steps.CallStep;
import engine.templates.viewHelper.steps.EasePositionStep;
import engine.templates.viewHelper.steps.enums.Ease;
import engine.templates.viewHelper.steps.EraseGraphicsStep;
import engine.templates.viewHelper.steps.TranslateStep;
import engine.templates.viewHelper.steps.WaitStep;
import engine.World;
import nape.phys.BodyType;

/**
 * ...
 * @author Jakegr
 */

class ViewManipulator 
 extends Entity
{
	static var Head:ViewManipulator;
	var Next:ViewManipulator;
	var Self:ViewManipulator;
	
	public var _CurrentlyDoing:MotionStep;
	var _Target:RueView;
	var _OnAllSequencesFinished:RueCallbackList;
	var _RecycleConnection:RueCallback;
	var _TargetWasRecycled:Bool;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(Group:EntityGroup, Target:RueView):ViewManipulator
	{
		var Vessel:ViewManipulator;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new ViewManipulator(); }
		Vessel.Setup(Group);
		Vessel._OnAllSequencesFinished = RueCallbackList.Create();
		Vessel._CurrentlyDoing = null;
		Vessel._Target = Target;
		Vessel._TargetWasRecycled = false;
		Vessel._RecycleConnection = Target.AddOnRecycleEvent(Vessel.TargetWasRecycled);
		
		return Vessel;
	}
	
	override public function PreUpdate():Void
	{
		DoesPreUpdate = false;
	}
	
	override public function Update():Void
	{
		if (_CurrentlyDoing != null)
		{
			_CurrentlyDoing.Step();
		}
		else
		{
			Recycle();
		}
	}
	
	override public function Draw():Void
	{
		DoesDraw = false;
	}
	
	private function TargetWasRecycled():Void
	{
		//recycle this entity and let go of the target if the target was recycled.
		_TargetWasRecycled = true;
		Recycle();
	}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			if (_CurrentlyDoing != null)
			{
				_CurrentlyDoing.KillButton();
			}
			
			if (!_TargetWasRecycled)
			{
				//trace("removing the node");
				_RecycleConnection.Recycle();
			}
			
			_OnAllSequencesFinished.TriggerAll();
			//_OnAllSequencesFinished.RecycleAll();
			_OnAllSequencesFinished.Recycle();
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void
	{
		Next = Head;
		Head = Self;
	}
	
	//{MANIPULATION FUNCTIONS
	public function StepAddOnSequenceFinished(AddMe:Void->Void):ViewManipulator
	{
		_OnAllSequencesFinished.Add(RueCallback.Create(AddMe));
		return Self;
	}
	
	public function StepAddToXY(ToX:Float, ToY:Float, XSpeed:Float = 10, YSpeed:Float = 10):ViewManipulator
	{
		if (_CurrentlyDoing != null){
			_CurrentlyDoing.AddStep(MotionStep.Create(TranslateStep.Create(ToX, ToY, XSpeed, YSpeed, _Target),Self));
		}
		else{
			_CurrentlyDoing = MotionStep.Create(TranslateStep.Create(ToX, ToY, XSpeed, YSpeed, _Target),Self);
		}
		return Self;
	}
	
	public function StepWait(ForThisLong:Float):ViewManipulator
	{
		if (_CurrentlyDoing != null)
		{
			_CurrentlyDoing.AddStep(MotionStep.Create(WaitStep.Create(ForThisLong), Self));
		}
		else
		{
			_CurrentlyDoing = MotionStep.Create(WaitStep.Create(ForThisLong), Self);
		}
		return Self;
	}
	
	public function StepCall(DoThis:Void->Void):ViewManipulator
	{
		if (_CurrentlyDoing != null)
		{
			_CurrentlyDoing.AddStep(MotionStep.Create(CallStep.Create(DoThis), Self));
		}
		else
		{
			_CurrentlyDoing = MotionStep.Create(CallStep.Create(DoThis), Self);
		}
		return Self;
	}
	
	public function StepAlpha(ToThis:Float, FromThis:Float, OverThisMuchTime:Float, EaseOption:Ease):ViewManipulator
	{
		if (_CurrentlyDoing != null)
		{
			_CurrentlyDoing.AddStep(MotionStep.Create(AlphaStep.Create(_Target, FromThis, ToThis, OverThisMuchTime, EaseOption), Self));
		}
		else
		{
			_CurrentlyDoing = MotionStep.Create(AlphaStep.Create(_Target, FromThis, ToThis, OverThisMuchTime, EaseOption), Self);
		}
		return Self;
	}
	
	public function StepEaseTowards( X:Float, Y:Float, OverThisMuchTime:Float, EaseOption:Ease):ViewManipulator
	{
		if (_CurrentlyDoing != null)
		{
			_CurrentlyDoing.AddStep(MotionStep.Create(EasePositionStep.Create(_Target, _Target._Position._X, _Target._Position._Y, X, Y, OverThisMuchTime, EaseOption), Self));
		}
		else
		{
			_CurrentlyDoing = MotionStep.Create(EasePositionStep.Create(_Target, _Target._Position._X, _Target._Position._Y, X, Y, OverThisMuchTime, EaseOption), Self);
		}
		return Self;
	}
	
	public function StepEraseGraphics():ViewManipulator
	{
		if (_CurrentlyDoing != null)
		{
			_CurrentlyDoing.AddStep(MotionStep.Create(EraseGraphicsStep.Create(_Target), Self));
		}
		else
		{
			_CurrentlyDoing = MotionStep.Create(EraseGraphicsStep.Create(_Target), Self);
		}
		return Self;
	}
	
	
	
	//}
	
		
	
}