package iso;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import iso.Iso.P2;
import iso.Iso.P3;
import iso.Iso.V5;

/**
 * ...
 * @author MSGHero
 */
class IsoGrid extends FlxSprite{
	
	var spacing:Int;
	var rowsX:Int;
	var colsY:Int;
	
	var drawLines:Bool;
	var colored:List<V5>;
	
	public var clearPrev:Bool;
	
	public function new(rowsX:Int, colsY:Int, spacing:Int, drawLines:Bool = true) {
		super();
		
		this.rowsX = rowsX;
		this.colsY = colsY;
		
		var w = Std.int(Iso.getCartXYZ(rowsX * spacing, -colsY * spacing, 0).x);
		var h = Std.int(Iso.getCartXYZ(rowsX * spacing, colsY * spacing, 0).y);
		makeGraphic(w, h, 0x0);
		
		var m = Iso.getIsoProjMatrix(XY, true);
		m.translate(w / 2, 0);
		var ls:LineStyle = { thickness:1, color:0xff000000 };
		var ds:DrawStyle = { matrix:m, smoothing:true };
		
		FlxSpriteUtil.drawRect(this, 0, 0, rowsX * spacing, colsY * spacing, FlxColor.WHITE, ls, ds);
		
		if (this.drawLines = drawLines) {
			
			var start:P2;
			var end:P2;
			/*
			for (i in 1...rowsX) {
				FlxSpriteUtil.drawLine(this, i * spacing, 0, i * spacing, colsY * spacing, ls, ds);
			}
			*/
			for (i in 1...colsY) {
				FlxSpriteUtil.drawLine(this, 0, i * spacing, rowsX * spacing, i * spacing, ls, ds);
			}
		}
		
		offset.x = w / 2;
		
		colored = new List<V5>();
		
		this.spacing = spacing;
	}
	
	private function _colorTileIso(v5:V5, storeTile:Bool = true):Void { // leaving these alone cuz they might not get used ever
		
		var base = Iso.getCart(v5);
		base.x += width / 2;
		
		var a = [FlxPoint.weak(base.x, base.y), FlxPoint.weak(base.x + spacing * Iso.SQRT_1_2, base.y + spacing * Iso.SQRT_1_6), FlxPoint.weak(base.x, base.y + spacing * 2 * Iso.SQRT_1_6), FlxPoint.weak(base.x - spacing * Iso.SQRT_1_2, base.y + spacing * Iso.SQRT_1_6)];
		
		var ls:LineStyle;
		if (drawLines) ls = { color:FlxColor.BLACK, thickness:1 };
		else ls = { };
		
		FlxSpriteUtil.drawPolygon(this, a, v5.color, ls);
		
		if (storeTile) colored.add(v5);
	}
	
	public function colorTileIso(color:Int, alpha:Float, ?p3:P3):Void {
		
		if (p3 == null) p3 = { x:0, y:0, z:0 };
		var av5 = { x : cast(Std.int(p3.x / spacing) * spacing, Float), y : cast(Std.int(p3.y / spacing) * spacing, Float), z : cast(Std.int(p3.z / spacing) * spacing, Float), color : color, alpha : alpha };
		
		if (av5.x / spacing >= rowsX || av5.x < 0 || av5.y / spacing >= colsY || av5.y < 0) return;
		
		if (!Lambda.exists(colored, function(v):Bool { return v.x == av5.x && v.y == av5.y && v.z == av5.z && v.color == av5.color && v.alpha == av5.alpha; } )) {
			if (clearPrev && !colored.isEmpty()) clearColored(FlxColor.WHITE, 1);
			_colorTileIso(av5, true);
		}
	}
	
	public function colorTileXY(color:Int, alpha:Float, ?ap2:P2, aiz:Float = 0):Void {
		if (ap2 == null) ap2 = { x:0, y:0 };
		colorTileIso(color, alpha, Iso.getIso(ap2, aiz));
	}
	
	public function clearColored(clearColor:Int, clearAlpha:Float):Void {
		// just redraw the whole thing?
		var v5:V5;
		while ((v5 = colored.pop()) != null) {
			
			v5.color = clearColor;
			v5.alpha = clearAlpha;
			_colorTileIso(v5, false);
		}
	}
	
}