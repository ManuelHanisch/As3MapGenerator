package de.mime.rw.world.gridData.voigraph 
{
	
	import de.mime.rw.world.gridData.voigraph.Center;
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Corner 
	{
		
		//public var index:int;
		public var gridPoint:Point; // location
		public var voiPoint:Point; //the voigraph coordinates (Number with 14 decimals usually), and the exact point that matches protruding edges
		
		
		public var touches:Vector.<Center>;
		public var protrudes:Vector.<Edge>;
		public var adjacent:Vector.<Corner>;
		
		public var border:Boolean; // at the edge of the map
		
		
		
		public function getWesternmostCenter():Center {
			
			var result:Center;			
			for each (var c:Center in touches) if (result === null || c.gridX <= result.gridX) result = c;			
			return result;				
			
		}
		public function getEasternmostCenter():Center {
			
			var result:Center;			
			for each (var c:Center in touches) if (result === null || c.gridX > result.gridX) result = c;			
			return result;				
			
		}
		
		
	}

}