package engine.helpers;

import engine.systems.TileRenderSystem;
import flash.system.System;

/**
 * ...
 * @author Jakegr
 */

class TileDesc 
{
	public var UIDS:Array<Int>; //UNIQUE IDS 
	public var DS:Array<Float>; //DELAYS
	public var TheTileSheet:TileSheetEntry;
	public var FrameCount:Int;
	
	public function new(TileSheetData:TileSheetEntry) 
	{
		FrameCount = 0;
		TheTileSheet = TileSheetData;
		DS = new Array<Float>();
		UIDS = new Array<Int>();
	}
	
	public static function CreateAnimationFrom(Sheet:TileSheetEntry, Additions:Array<TileDesc>):TileDesc
	{
		var NewDesc:TileDesc = new TileDesc(Sheet);
		
		var count:Int = Additions.length;
		
		for (i in 0...count)
		{
			var Current:TileDesc = Additions[i];
			NewDesc.UIDS.push(Current.UIDS[0]);
			NewDesc.DS.push(Current.DS[0]);
			NewDesc.FrameCount++;
		}
		
		return NewDesc;
	}
	
	public function AddFrame_1(ID:Int, D:Float):TileDesc
	{
		FrameCount = 1; UIDS.push(ID); DS.push(D);
		return this;
	}
	
	public function AddFrame_2(ID:Int, D:Float, ID2:Int, D2:Float):TileDesc
	{
		FrameCount = 2; 
		UIDS.push(ID); UIDS.push(ID2); 
		DS.push(D); DS.push(D2);
		return this;
	}
	
	public function AddFrame_3(ID:Int, D:Float, ID2:Int, D2:Float, ID3:Int, D3:Float):TileDesc
	{
		FrameCount = 3; 
		UIDS.push(ID); UIDS.push(ID2); UIDS.push(ID3);
		DS.push(D); DS.push(D2); DS.push(D3);
		return this;
	}
	
	public function AddFrame_4(ID:Int, D:Float, ID2:Int, D2:Float, ID3:Int, D3:Float, ID4:Int, D4:Float):TileDesc
	{
		FrameCount = 4; 
		UIDS.push(ID); UIDS.push(ID2); UIDS.push(ID3); UIDS.push(ID4);
		DS.push(D); DS.push(D2); DS.push(D3); DS.push(D4);
		return this;
	}
	
	public function AddFrame_5(ID:Int, D:Float, ID2:Int, D2:Float, ID3:Int, D3:Float, ID4:Int, D4:Float, ID5:Int, D5:Float):TileDesc
	{
		FrameCount = 5; 
		UIDS.push(ID); UIDS.push(ID2); UIDS.push(ID3); UIDS.push(ID4); UIDS.push(ID5);
		DS.push(D); DS.push(D2); DS.push(D3); DS.push(D4); DS.push(D5);
		return this;
	}
	
	public function AddFrame_6(ID:Int, D:Float, ID2:Int, D2:Float, ID3:Int, D3:Float, ID4:Int, D4:Float, ID5:Int, D5:Float, ID6:Int, D6:Float):TileDesc
	{
		FrameCount = 6; 
		UIDS.push(ID); UIDS.push(ID2); UIDS.push(ID3); UIDS.push(ID4); UIDS.push(ID5); UIDS.push(ID6);
		DS.push(D); DS.push(D2); DS.push(D3); DS.push(D4); DS.push(D5); DS.push(D6);
		return this;
	}
	
	public function AddFrame_7(ID:Int, D:Float, ID2:Int, D2:Float, ID3:Int, D3:Float, ID4:Int, D4:Float, ID5:Int, D5:Float, ID6:Int, D6:Float, ID7:Int, D7:Float):TileDesc
	{
		FrameCount = 7; 
		UIDS.push(ID); UIDS.push(ID2); UIDS.push(ID3); UIDS.push(ID4); UIDS.push(ID5); UIDS.push(ID6); UIDS.push(ID7);
		DS.push(D); DS.push(D2); DS.push(D3); DS.push(D4); DS.push(D5);  DS.push(D6); DS.push(D7);
		return this;
	}
	
	public function AddFrame_8(ID:Int, D:Float, ID2:Int, D2:Float, ID3:Int, D3:Float, ID4:Int, D4:Float, ID5:Int, D5:Float, ID6:Int, D6:Float, ID7:Int, D7:Float
							  ,ID8:Int, D8:Float):TileDesc
	{
		FrameCount = 8; 
		UIDS.push(ID); UIDS.push(ID2); UIDS.push(ID3); UIDS.push(ID4); UIDS.push(ID5); UIDS.push(ID6); UIDS.push(ID7); UIDS.push(ID8);
		DS.push(D); DS.push(D2); DS.push(D3); DS.push(D4); DS.push(D5);  DS.push(D6); DS.push(D7); DS.push(D8);
		return this;
	}
	
	public function AddFrame_9(ID:Int, D:Float, ID2:Int, D2:Float, ID3:Int, D3:Float, ID4:Int, D4:Float, ID5:Int, D5:Float, ID6:Int, D6:Float, ID7:Int, D7:Float
							  ,ID8:Int, D8:Float,ID9:Int, D9:Float):TileDesc
	{
		FrameCount = 9; 
		UIDS.push(ID); UIDS.push(ID2); UIDS.push(ID3); UIDS.push(ID4); UIDS.push(ID5); UIDS.push(ID6); UIDS.push(ID7); UIDS.push(ID8); UIDS.push(ID9);
		DS.push(D); DS.push(D2); DS.push(D3); DS.push(D4); DS.push(D5);  DS.push(D6); DS.push(D7); DS.push(D8); DS.push(D9);
		return this;
	}
	
	public function AddFrame_10(ID:Int, D:Float, ID2:Int, D2:Float, ID3:Int, D3:Float, ID4:Int, D4:Float, ID5:Int, D5:Float, ID6:Int, D6:Float, ID7:Int, D7:Float
							  ,ID8:Int, D8:Float,ID9:Int, D9:Float,ID10:Int, D10:Float):TileDesc
	{
		FrameCount = 10; 
		UIDS.push(ID); UIDS.push(ID2); UIDS.push(ID3); UIDS.push(ID4); UIDS.push(ID5); UIDS.push(ID6); UIDS.push(ID7); UIDS.push(ID8); UIDS.push(ID9); UIDS.push(ID10);
		DS.push(D); DS.push(D2); DS.push(D3); DS.push(D4); DS.push(D5);  DS.push(D6); DS.push(D7); DS.push(D8); DS.push(D9); DS.push(D10);
		return this;
	}
	
	public function AddFrame_11(Data:Array<Float>):TileDesc
	{
		FrameCount = 11; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_12(Data:Array<Float>):TileDesc
	{
		FrameCount = 12; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_13(Data:Array<Float>):TileDesc
	{
		FrameCount = 13; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_14(Data:Array<Float>):TileDesc
	{
		FrameCount = 14; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_15(Data:Array<Float>):TileDesc
	{
		FrameCount = 15; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_16(Data:Array<Float>):TileDesc
	{
		FrameCount = 16; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_17(Data:Array<Float>):TileDesc
	{
		FrameCount = 17; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_18(Data:Array<Float>):TileDesc
	{
		FrameCount = 18; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_19(Data:Array<Float>):TileDesc
	{
		FrameCount = 19; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_20(Data:Array<Float>):TileDesc
	{
		FrameCount = 20; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_21(Data:Array<Float>):TileDesc
	{
		FrameCount = 21; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_22(Data:Array<Float>):TileDesc
	{
		FrameCount = 22; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_23(Data:Array<Float>):TileDesc
	{
		FrameCount = 23; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_24(Data:Array<Float>):TileDesc
	{
		FrameCount = 24; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	public function AddFrame_25(Data:Array<Float>):TileDesc
	{
		FrameCount = 25; 
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}
	
	//takes any number of frames.
	public function AddFrames(Data:Array<Float>):TileDesc
	{
		FrameCount = 0;
		var Interval:Int = 1;
		for (i in 0...Data.length)
		{
			if (Interval == 1) //odd, first number, these will be the IDS
			{
				UIDS.push(Std.int(Data[i]));
				FrameCount++;
			}
			else //even, second number, this will be the delays
			{
				DS.push(Data[i]);
			}
			Interval *= -1;
		}
		
		return this;
	}

}