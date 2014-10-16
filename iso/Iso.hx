package iso;
import iso.Iso.Axis;
import iso.Iso.P2;
import iso.Iso.P3;
import openfl.geom.Matrix;

/**
 * Handy-dandy helpers for the Cartesian plane and Isometric/Dimetric space.
 * @author MSGHero
 */
class Iso{

	/* AXES
	 * 
	 *    .
	 *   /|\
	 *  / | \
	 * +Y | +X
	 *    |
	 *   +Z
	*/
	
	public static inline var SQRT_1_2:Float = 0.70710678118;
	public static inline var SQRT_1_6:Float = 0.40824829046;
	public static inline var SQRT_2:Float = 1.41421356237;
	public static inline var SQRT_3:Float = 1.73205080757;
	public static inline var SQRT_6:Float = 2.44948974278;
	
	static var proj:Matrix = new Matrix(0, 0, 0, 0);
	
	public static inline function getX(x:Float, y:Float, z:Float):Float {
	#if (isometric || dimetric)
		return (x - y) * SQRT_1_2;
	#else
		return 0;
	#end
	}
	
	public static inline function getY(x:Float, y:Float, z:Float):Float {
	#if isometric
		return (x + y + 2 * z) * SQRT_1_6;
	#elseif dimetric
		return ((x + y) * SQRT_1_2 + z * SQRT_3) / 2;
	#else
		return 0;
	#end
	}
	
	public static inline function getIX(x:Float, y:Float, z:Float = 0):Float {
	#if isometric
		return x * SQRT_1_2 + SQRT_6 * y / 2 - z;
	#elseif dimetric
		return x * SQRT_1_2 + SQRT_2 * y - SQRT_6 / 2 * z;
	#else
		return 0;
	#end
	}
	
	public static inline function getIY(x:Float, y:Float, z:Float = 0):Float {
	#if isometric
		return -x * SQRT_1_2 + SQRT_6 * y / 2 + z;
	#elseif dimetric
		return -x * SQRT_1_2 + SQRT_2 * y - SQRT_6 / 2 * z;
	#else
		return 0;
	#end
	}
	
	public static inline function getIZ(x:Float, y:Float, z:Float = 0):Float {
	#if (isometric || dimetric)
		return z;
	#else
		return 0;
	#end
	}
	
	public static inline function getCart(p3:P3, ?p2:P2):P2 {
		return getCartXYZ(p3.x, p3.y, p3.z, p2);
	}
	
	public static function getCartXYZ(x:Float, y:Float, z:Float, ?p2:P2):P2 {
		if (p2 == null) p2 = { x : 0, y : 0 };
		p2.x = getX(x, y, z); p2.y = getY(x, y, z);
		return p2;
	}
	
	public static inline function getIso(p2:P2, z:Float = 0, ?p3:P3):P3 {
		return getIsoXY(p2.x, p2.y, z, p3);
	}
	
	public static function getIsoXY(x:Float, y:Float, z:Float = 0, ?p3:P3):P3 {
		if (p3 == null) p3 = { x : 0, y : 0, z : 0 };
		p3.x = getIX(x, y, z); p3.y = getIY(x, y, z); p3.z = getIZ(x, y, z);
		return p3;
	}
	
	public static function getIsoProjMatrix(plane:Axis = XY, createNew:Bool = true):Matrix {
		
		/*
		 * Master iso matrix:
			 *    ix        iy         iz
			 *   SQRT_1_2  -SQRT_1_2  0
			 *   SQRT_1_6  SQRT_1_6   2 * SQRT_1_6
			 *   0         0          1
			 * 
		 * dimetric:
			 *    ix            iy            iz
			 *   SQRT_1_2      -SQRT_1_2     0
			 *   SQRT_1_2 / 2  SQRT_1_2 / 2  SQRT_3 / 2
			 *   0             0             1
			 * 
		 * tx,ty shift topleft of rect to top pt (XY: w/2,0  YZ: w,0  XZ: 0,0)
		 * offset shifts topleft of rect to regis pt (XY: w/2,0  YZ: w,2 * SQRT_1_6 * h  XZ: 0,2 * SQRT_1_6 * h)
		*/
		
		switch (plane) {
		#if isometric
			case XY:
				proj.setTo(SQRT_1_2, SQRT_1_6, -SQRT_1_2, SQRT_1_6, 0, 0); // etc
			case YZ:
				proj.a = -SQRT_1_2; proj.b = SQRT_1_6; proj.c = 0; proj.d = 2 * SQRT_1_6;
			case XZ:
				proj.a = SQRT_1_2; proj.b = SQRT_1_6; proj.c = 0; proj.d = 2 * SQRT_1_6;
		#elseif dimetric
			case XY:
				proj.a = SQRT_1_2; proj.b = SQRT_1_2 / 2; proj.c = -SQRT_1_2; proj.d = SQRT_1_2 / 2;
			case YZ:
				proj.a = -SQRT_1_2; proj.b = SQRT_1_2 / 2; proj.c = 0; proj.d = SQRT_3 / 2;
			case XZ:
				proj.a = SQRT_1_2; proj.b = SQRT_1_2 / 2; proj.c = 0; proj.d = SQRT_3 / 2;
		#end
			default: throw "Invalid Axis type. Must be exactly 2-dimensional";
		}
		
		if (createNew) return proj.clone();
		else return proj;
	}
	
	public static inline function isWithin(n:Float, start:Float, length:Float, equalTo:Bool):Bool {
		if (equalTo) return n >= start && n <= start + length;
		return n > start && n < start + length;
	}
	
	public static function overlap(start1:Float, end1:Float, start2:Float, end2:Float, equalTo:Bool = true):Bool {
		return isWithin(start1, start2, end2, equalTo) || isWithin(start1 + end1, start2, end2, equalTo) ||
			   isWithin(start2, start1, end1, equalTo) || isWithin(start2 + end2, start1, end1, equalTo);
	}
	
	public static function cartInBounds(pt:P2, boundsPos:P2, bounds:P2, equalTo:Bool = true):Bool {
		return isWithin(pt.x, boundsPos.x, bounds.x, equalTo) && isWithin(pt.y, boundsPos.y, bounds.y, equalTo);
	}
	
	public static function isoInBounds(pt:P3, boundsPos:P3, bounds:P3, equalTo:Bool = true):Bool {
		return isWithin(pt.x, boundsPos.x, bounds.x, equalTo) && isWithin(pt.y, boundsPos.y, bounds.y, equalTo) && isWithin(pt.z, boundsPos.z, bounds.z, equalTo);
	}
	
	public static function cartOverlapBounds(rangePos:P2, range:P2, boundsPos:P2, bounds:P2, axes:Axis = XY, equalTo:Bool = true):Bool {
		
		var b = true;
		if (axes == X || axes == XY || axes == XZ || axes == XYZ) b = overlap(rangePos.x, range.x, boundsPos.x, bounds.x, equalTo);
		if (b && (axes == Y || axes == XY || axes == YZ || axes == XYZ)) b = overlap(rangePos.y, range.y, boundsPos.y, bounds.y, equalTo);
		
		return b;
	}
	
	public static function isoOverlapBounds(rangePos:P3, range:P3, boundsPos:P3, bounds:P3, axes:Axis = XYZ, equalTo:Bool = true):Bool {
		
		var b = true;
		if (axes == X || axes == XY || axes == XZ || axes == XYZ) b = overlap(rangePos.x, range.x, boundsPos.x, bounds.x, equalTo);
		if (b && (axes == Y || axes == XY || axes == YZ || axes == XYZ)) b = overlap(rangePos.y, range.y, boundsPos.y, bounds.y, equalTo);
		if (b && (axes == Z || axes == XZ || axes == YZ || axes == XYZ)) b = overlap(rangePos.z, range.z, boundsPos.z, bounds.z, equalTo);
		
		return b;
	}
	
	public static function dist(pos1:P2, pos2:P2):Float {
		return Math.sqrt(distSq(pos1, pos2));
	}
	
	public static function isoDist(pos1:P3, pos2:P3):Float {
		return Math.sqrt(isoDistSq(pos1, pos2));
	}
	
	public static function distSq(pos1:P2, pos2:P2):Float {
		return (pos2.x - pos1.x) * (pos2.x - pos1.x) + (pos2.y - pos1.y) * (pos2.y - pos1.y);
	}
	
	public static function isoDistSq(pos1:P3, pos2:P3):Float {
		return (pos2.x - pos1.x) * (pos2.x - pos1.x) + (pos2.y - pos1.y) * (pos2.y - pos1.y) + (pos2.z - pos1.z) * (pos2.z - pos1.z);
	}
	
	public static function sort(order:Int, iso1:IIso, iso2:IIso):Int {
		// ascending = -1, descending = 1
		// order doesn't matter if more than one initial comparison is true
		// in the case of MC Escher situations: good luck
		
		if (iso1 == null || iso2 == null) return 0;
		
		// aabb non-intersection check
		if (iso1.getMin(X) >= iso2.getMax(X)) return -order;
		if (iso2.getMin(X) >= iso1.getMax(X)) return order;
		
		if (iso1.getMin(Y) >= iso2.getMax(Y)) return -order;
		if (iso2.getMin(Y) >= iso1.getMax(Y)) return order;
		
		if (iso1.getMin(Z) >= iso2.getMax(Z)) return order; // flipped since +z is down
		if (iso2.getMin(Z) >= iso1.getMax(Z)) return -order;
		
		// aabb intersection check
		if (iso1.getMax(X) > iso2.getMax(X)) return -order;
		if (iso2.getMax(X) > iso1.getMax(X)) return order;
		
		if (iso1.getMax(Y) > iso2.getMax(Y)) return -order;
		if (iso2.getMax(Y) > iso1.getMax(Y)) return order;
		
		if (iso1.getMin(Z) < iso2.getMin(Z)) return -order;
		if (iso2.getMin(Z) < iso1.getMin(Z)) return order;
		
		return (iso2.depth - iso1.depth) * order; // last resort for consistency
	}
	
	// for graphics
	
	public static function getBoxEdges(ii:IIso, shiftCenter:Bool = true, local:Bool = true):Array<Edge2> {
		// order:
		// top: from back pt ccw
		// sides: left, middle, right, back (covered)
		// bot: from back pt ccw (first and last covered)
		
		var minx = ii.getMin(X);
		var maxx = ii.getMax(X);
		var miny = ii.getMin(Y);
		var maxy = ii.getMax(Y);
		var minz = ii.getMin(Z);
		var maxz = ii.getMax(Z);
		
		if (local) {
			minx -= ii.ipos.x;
			maxx -= ii.ipos.x;
			miny -= ii.ipos.y;
			maxy -= ii.ipos.y;
			minz -= ii.ipos.z;
			maxz -= ii.ipos.z;
		}
		
		var xyz:P3 = { x:minx, y:miny, z:maxz };
		var xmz:P3 = { x:minx, y:maxy, z:maxz };
		var mmz:P3 = { x:maxx, y:maxy, z:maxz };
		var myz:P3 = { x:maxx, y:miny, z:maxz };
		var xym:P3 = { x:minx, y:miny, z:minz };
		var xmm:P3 = { x:minx, y:maxy, z:minz };
		var mmm:P3 = { x:maxx, y:maxy, z:minz };
		var mym:P3 = { x:maxx, y:miny, z:minz };
		
		// doesn't account for line thickness
		var shiftBy:P2 = { x : getCartXYZ(0, miny - maxy, 0).x, y : getCartXYZ(0, 0, maxz - minz).y };
		
		var e3s:Array<Edge3> = [
			{ start:xym, end:xmm, visible:true },
			{ start:xmm, end:mmm, visible:true },
			{ start:mmm, end:mym, visible:true },
			{ start:mym, end:xym, visible:true },
			
			{ start:xmm, end:xmz, visible:true },
			{ start:mmm, end:mmz, visible:true },
			{ start:mym, end:myz, visible:true },
			{ start:xym, end:xyz, visible:false },
			
			{ start:xyz, end:xmz, visible:false },
			{ start:xmz, end:mmz, visible:true },
			{ start:mmz, end:myz, visible:true },
			{ start:myz, end:xyz, visible:false }
		];
		
		var e2s:Array<Edge2> = [];
		var st:P2, en:P2;
		for (e3 in e3s) {
			
			st = getCart(e3.start);
			en = getCart(e3.end);
			
			if (shiftCenter) {
				st.x += shiftBy.x; st.y += shiftBy.y;
				en.x += shiftBy.x; en.y += shiftBy.y;
			}
			
			e2s.push( { start : st, end : en, visible : e3.visible } );
		}
		
		return e2s;
	}
	
	public static function getBoxFaces(ii:IIso, shiftCenter:Bool = true, local:Bool = true):Array<Face2> {
		
		var edges = getBoxEdges(ii, shiftCenter, local);
		
		var temp:P3;
		var e0 = edges[0];
		var e1 = edges[1];
		var e2 = edges[2];
		var e3 = edges[3];
		var e4 = edges[4];
		var e5 = edges[5];
		var e6 = edges[6];
		var e7 = edges[7];
		var e8 = edges[8];
		var e9 = edges[9];
		var e10 = edges[10];
		var e11 = edges[11];
		
		// order:
		// top, left, right, backleft, backright, bot
		var faces:Array<Face2> = [
			{ pts:[e0.start, e1.start, e2.start, e3.start], visible:true },
			{ pts:[e4.start, e9.start, e5.end, e1.end], visible:true },
			{ pts:[e5.end, e10.end, e6.start, e2.start], visible:true },
			{ pts:[e0.start, e4.start, e8.end, e7.end], visible:false },
			{ pts:[e3.start, e7.start, e11.end, e6.end], visible:false },
			{ pts:[e8.start, e9.start, e10.start, e11.start], visible:false },
		];
		
		return faces;
	}
	
	public static function drawIsoBox(ii:IIso, drawFunc:Int->Int->Int->Int->Void, local:Bool = true, edgesOnly:Bool = false, drawHidden:Bool = false):Void {
		
		if (edgesOnly) {
			
			var edges = getBoxEdges(ii, true, local);
			
			for (edge in edges) {
				if (edge.visible || drawHidden) drawFunc(Std.int(edge.start.x), Std.int(edge.start.y), Std.int(edge.end.x), Std.int(edge.end.y));
			}
		}
		
		else {
			// faces
		}
	}
}

// Consider making these classes for memory (getCart slight mem leak possibly from structs)
// only in flash tho, so dynamic/structural issue?
typedef P2 = {
	x:Float,
	y:Float
}

typedef P3 = {> P2,
	z:Float
}

typedef V5 = {> P3,
	color:Int,
	alpha:Float
}

typedef Edge2 = {
	start:P2,
	end:P2,
	visible:Bool
}

typedef Face2 = {
	pts:Array<P2>,
	visible:Bool
}

typedef Edge3 = {
	start:P3,
	end:P3,
	visible:Bool
}

typedef Face3 = {
	pts:Array<P3>,
	visible:Bool
}

@:enum
abstract Axis(Int) {
	var X = 0;
	var Y = 1;
	var Z = 2;
	var XY = 3;
	var YZ = 4;
	var XZ = 5;
	var XYZ = 6;
}