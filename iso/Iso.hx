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
	
	/**
	 * Gets the cartesian x coordinate from an isometric X,Y,Z
	 * @param	x	Isometric X
	 * @param	y	Isometric Y
	 * @param	z	Isometric Z
	 * @return	Cartesian X
	 */
	public static inline function getX(x:Float, y:Float, z:Float):Float {
	#if (isometric || dimetric)
		return (x - y) * SQRT_1_2;
	#else
		return 0;
	#end
	}
	
	/**
	 * Gets the cartesian y coordinate from an isometric X,Y,Z
	 * @param	x	Isometric X
	 * @param	y	Isometric Y
	 * @param	z	Isometric Z
	 * @return	Cartesian Y
	 */
	public static inline function getY(x:Float, y:Float, z:Float):Float {
	#if isometric
		return (x + y + 2 * z) * SQRT_1_6;
	#elseif dimetric
		return ((x + y) * SQRT_1_2 + z * SQRT_3) / 2;
	#else
		return 0;
	#end
	}
	
	/**
	 * Gets the isometric X coordinate from a cartesian X,Y and optional isometric Z
	 * There are an infinite number of isometric X,Y,Z that equal a cartesian X,Y, so Z must be specified, default: 0
	 * @param	x	Cartesian X
	 * @param	y	Cartesian Y
	 * @param	iz	Isometric Z
	 * @return	Isometric X
	 */
	public static inline function getIX(x:Float, y:Float, iz:Float = 0):Float {
	#if isometric
		return x * SQRT_1_2 + SQRT_6 * y / 2 - iz;
	#elseif dimetric
		return x * SQRT_1_2 + SQRT_2 * y - SQRT_6 / 2 * iz;
	#else
		return 0;
	#end
	}
	
	/**
	 * Gets the isometric Y coordinate from a cartesian X,Y and optional isometric Z
	 * There are an infinite number of isometric X,Y,Z that equal a cartesian X,Y, so some Z must be specified, default: 0
	 * @param	x	Cartesian X
	 * @param	y	Cartesian Y
	 * @param	iz	Isometric Z
	 * @return	Isometric Y
	 */
	public static inline function getIY(x:Float, y:Float, iz:Float = 0):Float {
	#if isometric
		return -x * SQRT_1_2 + SQRT_6 * y / 2 + iz;
	#elseif dimetric
		return -x * SQRT_1_2 + SQRT_2 * y - SQRT_6 / 2 * iz;
	#else
		return 0;
	#end
	}
	
	/**
	 * Gets the isometric Z coordinate from a cartesian X,Y and optional isometric Z
	 * There are an infinite number of isometric X,Y,Z that equal a cartesian X,Y, so some Z must be specified, default: 0
	 * @param	x	Cartesian X
	 * @param	y	Cartesian Y
	 * @param	iz	Isometric Z
	 * @return	Isometric Z
	 */
	public static inline function getIZ(x:Float, y:Float, iz:Float = 0):Float {
	#if (isometric || dimetric)
		return iz;
	#else
		return 0;
	#end
	}
	
	/**
	 * Gets the cartesian X,Y from an isometric X,Y,Z
	 * @param	p3	Isometric X,Y,Z
	 * @param	p2	Optional P2 to reuse, otherwise a new P2 is created
	 * @return	P2 of cartesian X,Y
	 */
	public static inline function getCart(p3:P3, ?p2:P2):P2 {
		return getCartXYZ(p3.x, p3.y, p3.z, p2);
	}
	
	/**
	 * Gets the cartesian X,Y from an isometric X,Y,Z
	 * @param	ix	Isometric X
	 * @param	iy	Isometric Y
	 * @param	iz	Isometric Z
	 * @param	p2	Optional P2 to reuse, otherwise a new P2 is created
	 * @return	P2 of cartesian X,Y
	 */
	public static function getCartXYZ(ix:Float, iy:Float, iz:Float, ?p2:P2):P2 {
		if (p2 == null) p2 = { x : 0, y : 0 };
		p2.x = getX(ix, iy, iz); p2.y = getY(ix, iy, iz);
		return p2;
	}
	
	/**
	 * Gets the isometric X,Y,Z from a cartesian X,Y and optional isometric Z
	 * There are an infinite number of isometric X,Y,Z that equal a cartesian X,Y, so some Z must be specified, default: 0
	 * @param	p2	Cartesian X,Y
	 * @param	iz	Isometric Z
	 * @param	p3	Optional P3 to reuse, otherwise a new P3 is created
	 * @return	P3 of isometric X,Y,Z
	 */
	public static inline function getIso(p2:P2, iz:Float = 0, ?p3:P3):P3 {
		return getIsoXY(p2.x, p2.y, iz, p3);
	}
	
	/**
	 * Gets the isometric X,Y,Z from a cartesian X,Y and optional isometric Z
	 * There are an infinite number of isometric X,Y,Z that equal a cartesian X,Y, so some Z must be specified, default: 0
	 * @param	x	Cartesian X
	 * @param	y	Cartesian Y
	 * @param	iz	Isometric Z
	 * @param	p3	Optional P3 to reuse, otherwise a new P3 is created
	 * @return	P3 of isometric X,Y,Z
	 */
	public static function getIsoXY(x:Float, y:Float, iz:Float = 0, ?p3:P3):P3 {
		if (p3 == null) p3 = { x : 0, y : 0, z : 0 };
		p3.x = getIX(x, y, iz); p3.y = getIY(x, y, iz); p3.z = getIZ(x, y, iz);
		return p3;
	}
	
	/**
	 * Gets the isometric projection matrix of a plane, useful for transforming a shape
	 * @example A rectangle may be transformed into a tile on the ground by transforming it in the XY plane
	 * @example A rectangle may be transformed into a thin wall by transforming it in the XZ or YZ plane
	 * @param	plane		2D Axis
	 * @param	createNew	Creates a new Matrix if true, otherwise uses a static one
	 * @return	A matrix containing the proper a,b,c,d properties. tx,ty, and additional offsets may be required
	 */
	public static function getIsoProjMatrix(plane:Axis = XY, createNew:Bool = true):Matrix {
		
		/*
		 * Matrix Equation: Isometric X,Y,Z = Matrix(plane) * Cartesian X,Y (z = 0)
		 * 
		 * Master iso matrix:
			 *    ix        iy         iz
			 * [ SQRT_1_2  -SQRT_1_2  0             [x
			 *   SQRT_1_6  SQRT_1_6   2 * SQRT_1_6   y
			 *   0         0          1           ]  0]
			 * 
		 * dimetric:
			 *     ix            iy            iz
			 * [ SQRT_1_2      -SQRT_1_2     0             [x
			 *   SQRT_1_2 / 2  SQRT_1_2 / 2  SQRT_3 / 2     y
			 *   0             0             1    ]         0]
		 * 
		 * 
		 * Set tx,ty equal to (XY: {width / 2, 0}  YZ: {width, 0}  XZ: {0, 0})
		 * Sprite offsets and such, set equal to (XY: {width / 2, 0}  YZ: {width, 2 * SQRT_1_6 * height or SQRT_3 / 2}  XZ: {0, 2 * SQRT_1_6 * height or SQRT_3 / 2})
		*/
		
		switch (plane) {
		#if isometric
			case XY:
				proj.a = SQRT_1_2; proj.b = SQRT_1_6; proj.c = -SQRT_1_2; proj.d = SQRT_1_6;
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
		
		proj.tx = proj.ty = 0;
		if (createNew) return proj.clone();
		else return proj;
	}
	
	/**
	 * Checks if n is between start and start + length
	 * @param	n
	 * @param	start
	 * @param	length
	 * @param	equalTo	If bounds are inclusive
	 * @return
	 */
	public static inline function isWithin(n:Float, start:Float, length:Float, equalTo:Bool):Bool {
		if (equalTo) return n >= start && n <= start + length;
		return n > start && n < start + length;
	}
	
	/**
	 * Checks if segment start1-end1 overlaps segment start2-end2
	 * @param	start1
	 * @param	end1
	 * @param	start2
	 * @param	end2
	 * @param	equalTo	If bounds are inclusive
	 * @return
	 */
	public static function overlap(start1:Float, end1:Float, start2:Float, end2:Float, equalTo:Bool = true):Bool {
		return isWithin(start1, start2, end2, equalTo) || isWithin(start1 + end1, start2, end2, equalTo) ||
			   isWithin(start2, start1, end1, equalTo) || isWithin(start2 + end2, start1, end1, equalTo);
	}
	
	/**
	 * Checks if cartesian pt is within rectangle boundsPos-bounds
	 * @param	pt			2D point
	 * @param	boundsPos	Starting position of the bounds
	 * @param	bounds		2D bounds
	 * @param	equalTo		If bounds are inclusive
	 * @return
	 */
	public static function cartInBounds(pt:P2, boundsPos:P2, bounds:P2, equalTo:Bool = true):Bool {
		return isWithin(pt.x, boundsPos.x, bounds.x, equalTo) && isWithin(pt.y, boundsPos.y, bounds.y, equalTo);
	}
	
	/**
	 * Checks if isometric pt is within 3D box boundsPos-bounds
	 * @param	pt			3D point
	 * @param	boundsPos	Starting position of the bounds
	 * @param	bounds		3D bounds
	 * @param	equalTo		If bounds are inclusive
	 * @return
	 */
	public static function isoInBounds(pt:P3, boundsPos:P3, bounds:P3, equalTo:Bool = true):Bool {
		return isWithin(pt.x, boundsPos.x, bounds.x, equalTo) && isWithin(pt.y, boundsPos.y, bounds.y, equalTo) && isWithin(pt.z, boundsPos.z, bounds.z, equalTo);
	}
	
	/**
	 * Checks if range overlaps bounds in the specified 1 or 2D Axis
	 * @param	rangePos	Starting position of the range
	 * @param	range		2D range
	 * @param	boundsPos	Starting position of the bounds
	 * @param	bounds		2D bounds
	 * @param	axes		Axes to check overlaps on: X, Y, or XY (X and Y)
	 * @param	equalTo		If bounds are inclusive
	 * @return
	 */
	public static function cartOverlapBounds(rangePos:P2, range:P2, boundsPos:P2, bounds:P2, axes:Axis = XY, equalTo:Bool = true):Bool {
		
		if (axes == Z) return false;
		
		var b = true;
		if (axes == X || axes == XY || axes == XZ || axes == XYZ) b = overlap(rangePos.x, range.x, boundsPos.x, bounds.x, equalTo);
		if (b && (axes == Y || axes == XY || axes == YZ || axes == XYZ)) b = overlap(rangePos.y, range.y, boundsPos.y, bounds.y, equalTo);
		
		return b;
	}
	
	/**
	 * Checks if range overlaps bounds in the specified 1, 2, or 3D Axis
	 * @param	rangePos	Starting position of the range
	 * @param	range		3D range
	 * @param	boundsPos	Starting position of the bounds
	 * @param	bounds		3D bounds
	 * @param	axes		Axes to check overlaps on: X, Y, Z, XY, YZ, XZ, XYZ
	 * @param	equalTo		If bounds are inclusive
	 * @return
	 */
	public static function isoOverlapBounds(rangePos:P3, range:P3, boundsPos:P3, bounds:P3, axes:Axis = XYZ, equalTo:Bool = true):Bool {
		
		var b = true;
		if (axes == X || axes == XY || axes == XZ || axes == XYZ) b = overlap(rangePos.x, range.x, boundsPos.x, bounds.x, equalTo);
		if (b && (axes == Y || axes == XY || axes == YZ || axes == XYZ)) b = overlap(rangePos.y, range.y, boundsPos.y, bounds.y, equalTo);
		if (b && (axes == Z || axes == XZ || axes == YZ || axes == XYZ)) b = overlap(rangePos.z, range.z, boundsPos.z, bounds.z, equalTo);
		
		return b;
	}
	
	/**
	 * Gets scalar distance between 2 P2s
	 * @param	pos1	2D point
	 * @param	pos2	2D point
	 * @return
	 */
	public static function dist(pos1:P2, pos2:P2):Float {
		return Math.sqrt(distSq(pos1, pos2));
	}
	
	/**
	 * Gets scalar distance between 2 P3s
	 * @param	pos1	3D point
	 * @param	pos2	3D point
	 * @return
	 */
	public static function isoDist(pos1:P3, pos2:P3):Float {
		return Math.sqrt(isoDistSq(pos1, pos2));
	}
	
	/**
	 * Gets squared scalar distance between 2 P2s
	 * @param	pos1	2D point
	 * @param	pos2	2D point
	 * @return
	 */
	public static function distSq(pos1:P2, pos2:P2):Float {
		return (pos2.x - pos1.x) * (pos2.x - pos1.x) + (pos2.y - pos1.y) * (pos2.y - pos1.y);
	}
	
	/**
	 * Gets squared scalar distance between 2 P3s
	 * @param	pos1	3D point
	 * @param	pos2	3D point
	 * @return
	 */
	public static function isoDistSq(pos1:P3, pos2:P3):Float {
		return (pos2.x - pos1.x) * (pos2.x - pos1.x) + (pos2.y - pos1.y) * (pos2.y - pos1.y) + (pos2.z - pos1.z) * (pos2.z - pos1.z);
	}
	
	/**
	 * Gives the sorting order of two iso objects
	 * May cause issues in a transitive sorting algo. Set iiso.depth to its current position in the array for best/most consistent results
	 * @param	order	-1 for ascending, 1 for descending
	 * @param	iso1
	 * @param	iso2
	 * @return	Negative if iso1 comes before iso2, positive if iso2 comes before iso2, 0 if order doesn't matter
	 */
	public static function sort(order:Int, iso1:IIso, iso2:IIso):Int {
		
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

/**
 * 2D Point Struct
 */
typedef P2 = {
	x:Float,
	y:Float
}

/**
 * 3D Point Struct
 */
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

/**
 * 1, 2, and 3D axes
 */
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