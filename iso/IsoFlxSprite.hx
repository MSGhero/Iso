package iso;

import flixel.FlxG;
import flixel.FlxSprite;
import iso.Iso.Axis;
import iso.Iso.P2;
import iso.Iso.P3;

/**
 * ...
 * @author MSGHero
 */
class IsoFlxSprite extends FlxSprite implements IIso{

	@:allow(iso)
	var p2:P2; // cache iso offset from cart
	var centerXY:P2;
	
	public var ipos(default, null):P3;
	public var ivel(default, null):P3;
	public var ibounds(default, null):P3;
	public var depth:Int;
	
	public function new() {
		super();
		p2 = { x:0, y:0 };
		centerXY = { x:0, y:0 };
		ipos = { x:0, y:0, z:0 }; ivel = { x:0, y:0, z:0 }; ibounds = { x:0, y:0, z:0 };
		depth = 0;
	}
	
	public static inline function sort(order:Int, flx1:FlxSprite, flx2:FlxSprite):Int {
		return Iso.sort(order, cast flx1, cast flx2);
	}
	
	public function setBounds(xW:Float, yW:Float, zH:Float):Void {
		ibounds.x = xW; ibounds.y = yW; ibounds.z = zH;
	}
	
	public function calcBounds():Void {
		// gets true iso bounds if you want things visually consistent
		ibounds.x = Iso.getIsoXY(frameWidth - offset.x, frameHeight - offset.y).x;
		ibounds.y = Iso.getIsoXY( -offset.x, frameHeight - offset.y).y;
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