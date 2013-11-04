package engine.templates;
import engine.base.RueObject;
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
	
	private function new() 
	{
		super();
		RueTextFieldSelf = this;
	}
	
	public static function Create(Parent:Sprite, X:Float, Y:Float, Size:Int, TheFont:Font, Editable:Bool = false, Selectable:Bool = false):RueTextField
	{
		var Vessel:RueTextField;
		if(RueTextFieldHead != null) { Vessel = RueTextFieldHead; RueTextFieldHead = RueTextFieldHead.RueTextFieldNext; }
		else { Vessel = new RueTextField(); }
		Vessel.InPool = false;
		
		Vessel._Parent = Parent;
		Vessel._Font = TheFont;

		Vessel._Text = new TextField();
		Vessel._Text.selectable = Selectable;
		Vessel._Text.mouseEnabled = Editable;
		Vessel._X = X;
		Vessel._Y = Y;
		Vessel._Size = Size;
		Vessel._Text.embedFonts = true;

		var TheTextFormat:TextFormat = new TextFormat(TheFont.fontName, Size);
		Vessel._Text.defaultTextFormat = TheTextFormat;
		Vessel._Text.setTextFormat(TheTextFormat);

		Parent.addChild(Vessel._Text);
		
		return Vessel;
	}
	
	public function ChangeTextTo(ToThis:String):Void
	{
		var X:Float = _Text.x;
		var Y:Float = _Text.y;
		
		_Parent.removeChild(Text); 

		_Text = new TextField();
		_Text.mouseEnabled = false;
		_Text.selectable = false;
		_Text.embedFonts = true;
		_Text.width = ToThis.length * (_Size+1);
		_Text.height = (_Size + 1);
		_Text.text = ThisWords;
		_TextForm = new TextFormat(_Font.fontName, _Size);
		_Text.setTextFormat(TextForm);
		_Parent.addChild(Text);
		_Text.x = X;
		_Text.y = Y;
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
	
	public function DrawFrom(ParentX:Float, ParentY:Float, CameraBound:Bool):Void 
	{
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