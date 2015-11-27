package de.mime.rw.utils 
{
	import de.mime.utils.math.PM_PRNG;
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class DropRateCalculators 
	{
		
		public function DropRateCalculators() 
		{
			
		}
		
		
		
		/**
		 *  
		 * @param	dropRates, vector with numerical dropRates
		 * @return the index position of the winner. 
		 */
		public static function PercentageLottery(dropRates:Vector.<int>,rng:PM_PRNG):int {
			
			
			var winnerIndex:int = -1;	
			
			if (dropRates.length > 0) {
				
			
				var span:int = 0;
				
				
				for each(var dr:int in dropRates) {
					span += dr;
					
				}
				
				if (span < 100) span = 100;
				
				var hit:int = rng.nextIntRange(0, span);
				
				
				//calculating winner
				span = 0;						
				for (var i:int = 0; i < dropRates.length; i++) {
					
					span += dropRates[i];
					
					if (hit <= span) {
						winnerIndex = i;
						break;
					}
					
				}
				
				return winnerIndex;
				
			}
			else return winnerIndex;
			
			
			
			
		}
		
	}

}