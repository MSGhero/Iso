package iso;
import iso.Iso.Axis;
import iso.Iso.P3;

/**
 * Things that have to be implemented for use with iso.Iso.
 * @author MSGHero
 */

interface IIso {

	/**
	 * 3D position
	 */
	var ipos(default, null):P3;
	/**
	 * 3D velocity
	 */
	var ivel(default, null):P3;
	/**
	 * 3D bounds, xWidth, yWidth, zHeight (negative z is upwards)
	 */
	var ibounds(default, null):P3;
	/**
	 * Depth var for last-resort depth sorting
	 */
	var depth:Int;
	/**
	 * Sets the 3D bounds of the iso, can be negative values
	 * @param	xW, X width
	 * @param	yW, Y width
	 * @param	zH, Z height (negative z is upwards)
	 */
	function setBounds(xW:Float, yW:Float, zH:Float):Void;
	/**
	 * Custom function to auto-calculate the bounds if need be
	 */
	function calcBounds():Void;
	/**
	 * Gets the minimum coordinate in one direction
	 * @param	ax A 1D axis
	 * @return	ipos or ipos + bounds in the given direction, whichever is smaller
	 */
	function getMin(ax:Axis):Float;
	/**
	 * Gets the maximum coordinate in one direction
	 * @param	ax A 1D axis
	 * @return	ipos or ipos + bounds in the given direction, whichever is larger
	 */
	function getMax(ax:Axis):Float;
}