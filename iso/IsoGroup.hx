package iso;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import iso.Iso.Axis;
import iso.Iso.P2;
import iso.Iso.P3;

/**
 * ...
 * @author MSGHero
 */
class IsoGroup extends FlxSpriteGroup implements IIso{

	var p2:P2; // cache iso offset from cart
	var centerXY:P2;
	
	var oldIpos:P3;
	public var ipos(default, null):P3;
	public var ivel(default, null):P3;
	public var ibounds(default, null):P3;
	public var depth:Int;

	public function new() {
		super();
		p2 = { x:0, y:0 };
		centerXY = { x:0, y:0 };
		ipos = { x:0, y:0, z:0 }; ivel = { x:0, y:0, z:0 }; ibounds = { x:0, y:0, z:0 };
		oldIpos = { x:0, y:0, z:0 };
		depth = 0;
	}
	
	public function setBounds(xW:Float, yW:Float, zH:Float):Void {
		ibounds.x = xW; ibounds.y = yW; ibounds.z = zH;
	}
	
	public function calcBounds():Void {
		
		var ii:IIso;
		for (sp in _sprites) {
			ii = cast sp;
			if (ibounds.x == 0 || ibounds.x > 0 && ii.ibounds.x > ibounds.x || ibounds.x < 0 && ii.ibounds.x < ibounds.x) ibounds.x = ii.ibounds.x;
			if (ibounds.y == 0 || ibounds.y > 0 && ii.ibounds.y > ibounds.y || ibounds.y < 0 && ii.ibounds.y < ibounds.y) ibounds.y = ii.ibounds.y;
			if (ibounds.z == 0 || ibounds.z > 0 && ii.ibounds.z > ibounds.z || ibounds.z < 0 && ii.ibounds.z < ibounds.z) ibounds.z = ii.ibounds.z;
		}
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
		
		_skipTransformChildren = true;
		
		x -= p2.x; // remove iso offset
		y -= p2.y;
		
		if (moves) {
			ipos.x += ivel.x * elapsed; ipos.y += ivel.y * elapsed; ipos.z += ivel.z * elapsed; // replacement for updateMotion
		}
		
		// x and y transforms happen already, no need to repeat here
		
		if (ipos.x != oldIpos.x) {
			transformChildren(ixTransform, ipos.x - oldIpos.x);
			oldIpos.x = ipos.x;
		}
		
		if (ipos.y != oldIpos.y) {
			transformChildren(iyTransform, ipos.y - oldIpos.y);
			oldIpos.y = ipos.y;
		}
		
		if (ipos.z != oldIpos.z) {
			transformChildren(izTransform, ipos.z - oldIpos.z);
			oldIpos.z = ipos.z;
		}
		
		Iso.getCart(ipos, p2);
		x += p2.x; // readd iso offset
		y += p2.y;
		
		_skipTransformChildren = false;
		
		group.update(elapsed);
	}
	
	override public function add(Sprite:FlxSprite):FlxSprite {
		
		var sprite:FlxSprite = cast Sprite;
		var ii:IIso = cast Sprite;
		var igroup:IsoGroup = Std.is(Sprite, IsoGroup) ? cast Sprite : null;
		
		sprite.x += x;
		sprite.y += y;
		
		if (ii != null) {
			
			ii.ipos.x += ipos.x;
			ii.ipos.y += ipos.y;
			ii.ipos.z += ipos.z;
			
			if (igroup != null) {
				igroup.oldIpos.x += ipos.x;
				igroup.oldIpos.y += ipos.y;
				igroup.oldIpos.z += ipos.z;
			}
		}
		
		sprite.alpha *= alpha;
		sprite.scrollFactor.copyFrom(scrollFactor);
		sprite.cameras = _cameras; // _cameras instead of cameras because get_cameras() will not return null
		return group.add(Sprite);
	}
	
	override public function transformChildren<V>(Function:FlxSprite->V->Void, Value:V):Void {
		super.transformChildren(Function, Value);
	}
	
	private inline function ixTransform(Sprite:FlxSprite, X:Float) { cast(Sprite, IIso).ipos.x += X; }
	private inline function iyTransform(Sprite:FlxSprite, Y:Float) { cast(Sprite, IIso).ipos.y += Y; }
	private inline function izTransform(Sprite:FlxSprite, Z:Float) { cast(Sprite, IIso).ipos.z += Z; }
}