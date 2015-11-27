package de.mime.rw
{
	import de.mime.rw.world.WorldBuilder;
	import flash.display.Sprite;	
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			
			var wb:WorldBuilder = new WorldBuilder().createWorld();
			addChild(wb.worldMap);
			
		}
		
	}
	
}