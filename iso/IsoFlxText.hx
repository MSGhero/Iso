package iso;

import flixel.FlxG;
import flixel.text.FlxText;
import iso.Iso.Axis;
import iso.Iso.P2;
import iso.Iso.P3;

/**
 * ...
 * @author MSGHero
 */
class IsoFlxText extends FlxText implements IIso{
	
	var p2:P2; // cache iso offset from cart
	
	public var ipos(default, null):P3;
	public var ivel(default, null):P3;
	public var ibounds(default, null):P3;
	public var depth:Int;
	
	public function new(X:Float=0, Y:Float=0, FieldWidth:Float=0, ?Text:String, Size:Int=8, EmbeddedFont:Bool=true) {
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		p2 = { x:0, y:0 };
		ipos = { x:0, y:0, z:0 }; ivel = { x:0, y:0, z:0 }; ibounds = { x:0, y:0, z:0 };
		depth = 0;
	}
	
	public function setBounds(xW:Float, yW:Float, zH:Float):Void {
		ibounds.x = xW; ibounds.y = yW; ibounds.z = zH;
	}
	
	public function calcBounds():Void {
		ibounds.x = Iso.getIsoXY(width - offset.x, height - offset.y).x;
		ibounds.y = Iso.getIsoXY( -offset.x, height - offset.y).y;
		ibounds.z = -offset.y;
	}
	
	public function getMin(ax:Axis):Float {
		switch (ax) {
			case X:
				return ibounds.x < 0 ? ipos.x + ibounds.x : ipos.x;
			case Y:
				return ibounds.y < 0 ? ipos.y + ibounds.y : ipos.y;
			case Z:
				return ibounds.z < 0 ? ipos.z + ibounds.z : ipos.z;
			default:
				return -1;
		}
	}
	
	public function getMax(ax:Axis):Float {
		switch (ax) {
			case X:
				return ibounds.x > 0 ? ipos.x + ibounds.x : ipos.x;
			case Y:
				return ibounds.y > 0 ? ipos.y + ibounds.y : ipos.y;
			case Z:
				return ibounds.z > 0 ? ipos.z + ibounds.z : ipos.z;
			default:
				return -1;
		}
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		x -= p2.x; // remove iso offset
		y -= p2.y;
		
		if (moves) {
			ipos.x += ivel.x * elapsed; ipos.y += ivel.y * elapsed; ipos.z += ivel.z * elapsed; // replacement for updateMotion
		}
		
		Iso.getCart(ipos, p2);
		x += p2.x; // readd iso offset
		y += p2.y;
	}
}