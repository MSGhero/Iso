package iso ;

import flixel.util.FlxColor;
import iso.IsoFlxSprite;
import iso.IsoFlxText;
import openfl.Lib;

/**
 * ...
 * @author MSGHero
 */
class IsoBar extends IsoGroup{

	var fore:IsoFlxSprite;
	var back:IsoFlxSprite;
	var perc:IsoFlxText;
	// future bar: how much something will use up (red if more than curr)
	// <= curr: alpha the right side of fore = to the future use
	// > curr: red bar how much will be used (alpha to see fore underneath)
	// something in perc text to show how much will remain (including negative if future > curr)
	
	public var max(default, set):Float;
	public var curr(default, set):Float = 0; // for neko, null int
	
	public function new(Max:Float, Width:Int, Height:Int, FColor:Int, BColor:Int, ShowText:Bool = false) {
		super();
		
		fore = new IsoFlxSprite();
		fore.makeGraphic(Width, Height, FColor);
		
		back = new IsoFlxSprite();
		back.makeGraphic(Width, Height, BColor);
		
		if (ShowText) {
			perc = new IsoFlxText(Width + 10);
			perc.setFormat(null, 16, FlxColor.BLACK, "center");
			perc.wordWrap = false;
		}
		
		add(back); add(fore); if (ShowText) add(perc);
		
		max = Max;
		
		setBounds(1, Width, Height); // sorta
		moves = false;
	}
	
	private function setPerc(Min:Float, Max:Float):Void {
		if (Min > Max) Min = Max;
		fore.scale.x = Min / Max;
		fore.x = x + fore.p2.x - p2.x + (fore.scale.x - 1) * back.width / 2; // i guess this makes sense
		if (perc != null) perc.text = '${Std.int(Min)}/${Std.int(Max)}';
	}
	
	private function set_curr(f:Float):Float {
		setPerc(f, max);
		return curr = f;
	}
	
	private function set_max(f:Float):Float {
		setPerc(curr, f);
		return max = f;
	}
	
}