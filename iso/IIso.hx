package iso;
import iso.Iso.Axis;
import iso.Iso.P3;

/**
 * Things that have to be implemented for use with iso.Iso.
 * @author MSGHero
 */

interface IIso {
  var ipos(default, null):P3;
  var ivel(default, null):P3;
  var ibounds(default, null):P3;
  var depth:Int;
  function setBounds(xW:Float, yW:Float, zH:Float):Void;
  function calcBounds():Void;
  function getMin(ax:Axis):Float;
  function getMax(ax:Axis):Float;
}