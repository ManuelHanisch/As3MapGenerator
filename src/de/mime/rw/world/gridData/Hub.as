package de.mime.rw.world.gridData 
{
	import de.mime.rw.world.gridData.voigraph.Center;
	
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Hub 
	{
		
		
		public var center:Center;
		private var _emptyhub:Boolean;
		
		//politics etc...
		
		
		
		
		public function Hub(voiCenter:Center = null) 
		{
			
			if (voiCenter == null) _emptyhub = true;
			else _emptyhub = false;
			
			center = voiCenter;
			
		}
		
		public function get emptyhub():Boolean {
			return _emptyhub;
		}
		
	}

}