package engine.templates;
import engine.base.Entity;
import engine.base.RueObject;
import engine.helpers.render.DrawStack;
import flash.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * ...
 * @author Jakegr
 */

class RueTextField extends RueObject implements IScreenGraphic
{
	static var RueTextFieldHead:RueTextField;
	var RueTextFieldNext:RueTextField;
	var RueTextFieldSelf:RueTextField;
	
	var _Parent:Sprite;
	var _Text:TextField;
	var _Font:Font;
	var _X:Float;
	var _Y:Float;
	var _Size:Int;
	var _Color:UInt;
	
	private function new() 
	{
		super();
		RueTextFieldSelf = this;
	}
	
	public static function Create(X:Float, Y:Float, Size:Int, TheFont:Font, Editable:Bool = false, Selectable:Bool = false, color:UInt = 0x5a1516):RueTextField
	{
		var Vessel:RueTextField;
		if(RueTextFieldHead != null) { Vessel = RueTextFieldHead; RueTextFieldHead = RueTextFieldHead.RueTextFieldNext; }
		else { Vessel = new RueTextField(); }
		Vessel.InPool = false;
		
		Vessel._Font = TheFont;

		Vessel._X = X;
		Vessel._Y = Y;
		Vessel._Size = Size;
		Vessel._Color = color;
		Vessel.ChangeTextTo("");

		return Vessel;
	}
	
	public function ChangeTextTo(ToThis:String):Void
	{
		if (_Text != null)
		{
			if (ToThis == _Text.text) { return; }
		}
		
		var X:Float = 0;
		var Y:Float = 0;
		
		if (_Text != null)
		{
			X = _Text.x;
			Y = _Text.y;	
		}
		
		
		if (_Parent != null)
		{
			_Parent.removeChild(_Text); 
		}

		_Text = new TextField();
		_Text.mouseEnabled = false;
		_Text.selectable = false;
		_Text.embedFonts = true;
		_Text.width = ToThis.length * (_Size+1);
		_Text.height = (_Size*1.5);
		_Text.text = ToThis;
		var _TextForm:TextFormat = new TextFormat(_Font.fontName, _Size, _Color );
		_Text.setTextFormat(_TextForm);
		if (_Parent != null)
		{
			_Parent.addChild(_Text); 
		}
		_Text.x = X;
		_Text.y = Y;
	}
	
	public function ChangeColor(ToThisColor:UInt):Void
	{
		_Color = ToThisColor;
		var ToThis:String = _Text.text;
		
		var X:Float = 0;
		var Y:Float = 0;
		if (_Text != null)
		{
			X = _Text.x;
			Y = _Text.y;	
		}
		if (_Parent != null)
		{
			_Parent.removeChild(_Text); 
		}

		_Text = new TextField();
		_Text.mouseEnabled = false;
		_Text.selectable = false;
		_Text.embedFonts = true;
		_Text.width = ToThis.length * (_Size+1);
		_Text.height = (_Size*1.5);
		_Text.text = ToThis;
		var _TextForm:TextFormat = new TextFormat(_Font.fontName, _Size, _Color );
		_Text.setTextFormat(_TextForm);
		if (_Parent != null)
		{
			_Parent.addChild(_Text); 
		}
		_Text.x = X;
		_Text.y = Y;
	}
	
	public function CenterTo(X:Float):Void
	{
		_X = X - _Text.textWidth / 2;
	}
	
	public function AlignTo(Y:Float):Void
	{
		_Y = Y - _Text.textHeight / 2;
	}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			_Parent.removeChild(_Text);
			_Text = null;
			_Parent = null;
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void
	{
		RueTextFieldNext = RueTextFieldHead;
		RueTextFieldHead = RueTextFieldSelf;
	}
	
	/* INTERFACE engine.templates.IScreenGraphic */
	
	public function DrawFrom(ParentX:Float, ParentY:Float, RenderTarget:DrawStack, CameraBound:Bool):Void 
	{
		if (_Parent == null)
		{
			_Parent = RenderTarget.Target;
			_Parent.addChild(_Text);
		}
		else
		if (RenderTarget.Target != _Parent)
		{
			_Parent.removeChild(_Text);
			RenderTarget.Target.addChild(_Text);
			_Parent = RenderTarget.Target;
		}
		//textfields are always camera bound
		_Text.x = ParentX + _X;
		_Text.y = ParentY + _Y;
	}
	
	public function SetRotation(Rot:Float):Void 
	{
		_Text.rotation = Rot;
	}
	
	public function SetAlpha(Alpha:Float):Void 
	{
		_Text.alpha = Alpha;
	}
		
	
}