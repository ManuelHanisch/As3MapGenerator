package de.mime.rw.world.gridData 
{
	
	import com.nodename.Delaunay.Voronoi;
	import de.mime.utils.ds.Array2DIterator;
	
	
	import de.mime.rw.world.gridData.voigraph.Center;
	import de.mime.rw.world.gridData.voigraph.Corner;
	import de.mime.rw.world.gridData.voigraph.Edge;
	import de.mime.rw.world.gridData.voigraph.Graph;
	import de.mime.rw.world.gridData.Biome;
	
	import de.mime.rw.utils.DropRateCalculators;
		
	import de.mime.utils.ds.Array2D;
	import de.mime.utils.geom.RandomPointsArray2D;
	
	import de.mime.utils.DictionaryUtils;	
	
	import de.mime.utils.math.PM_PRNG;
	
	
	import flash.utils.Dictionary;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Grid 
	{
		
		
		public var rectangle:Rectangle;	
		
		//for other classes that use grid, so u dont have to send width/height as parameter and the above rectangle should be obsolete in the future (todo)
		public var width:int; 
		public var height:int;
		
		public var voimap:Graph;
		
		public var locationGrid:Array2D;
		public var theEmptyHub:Hub;
				
		private var _temperatureMaps:Vector.<TemperatureMap>;
		private var _rainMaps:Vector.<RainMap>;		
		private var _temperatureMap:TemperatureMap;
		private var _rainMap:RainMap;		
		
		private var _biomeDiagramm:BiomeDiagramm;		
		public var biomes:Dictionary;
		public var _oceanBiome:Biome;
		
		public var environements:Dictionary;
		
		
		
		private static const _XMLPATH:String = "mods/default/";
		
		
		
		
		public function Grid(rng:PM_PRNG, width:uint, travelSpotsCount:uint, tempMapsXML:XML, rainMapsXML:XML, biomesXML:XML, envXML:XML) {
			
			
			this.width = width;
			this.height = width;			
			this.rectangle = new Rectangle(0, 0, width, width);	
			
			
			this.voimap = new Graph(new RandomPointsArray2D(rectangle.width,rectangle.height,travelSpotsCount,2,1,rng).points, rectangle);
			
			
			createTemperatureMaps(tempMapsXML);
			createRainMaps(rainMapsXML);	
			
			_temperatureMap = _temperatureMaps[0];
			_rainMap = _rainMaps[0];
			
			createEnvironments(envXML);			
			createBiomes(biomesXML);	
			
			_biomeDiagramm = new BiomeDiagramm(biomes);
			
			
			theEmptyHub = new Hub();
			createLocationGrid();	
			
			
			
			addBiomes();
			
			addEnvironments(rng);
			
			
			
			
		}
		
		
		private function createLocationGrid():void {
			
			
			createEmptyLocations();
			
			addAreasAndCenters();						
			addCornersAndEdges();
			
			//fill rest of locations:
			fillAreasAroundCenters();
			
			addTemperaturesAndRain();
			
			
			
		}
		
		private function createEmptyLocations():void {
			
			this.locationGrid = new Array2D(rectangle.width, rectangle.height);	
			
			for (var x:int = 0; x < rectangle.height; x++) {
				for (var y:int = 0; y < rectangle.width; y++) {
					
					locationGrid.set(x,y,new Location(x,y,theEmptyHub));
					
				}
				
			}
			
		}
		
		
		
		private function addAreasAndCenters():void {
			
			var t_loc:Location;
			
			for each (var c:Center in voimap.centers) {
				
				t_loc = locationGrid.get(c.gridX, c.gridY);
				t_loc.setHub(new Hub(c));	
				
				
			}
			
		}
		
		private function addCornersAndEdges():void {
				
			var t_loc:Location;
			var t_p:Center;
			
			var path:int = 0;
			
			//add corners
			for each (var co:Corner in voimap.corners) { 
				
				t_loc = locationGrid.get(co.gridPoint.x, co.gridPoint.y);
				t_loc.onCorners.push(co);
				
				t_p = co.getWesternmostCenter();	
				
				t_loc.setHub(Location(locationGrid.get(t_p.gridX, t_p.gridY)).hub);
				
				
			}	
			
			//add edge lines
			var t_path:Vector.<Point>;
			var t_h:Hub;
			for each (var e:Edge in voimap.edges) { 				
				
					
				t_p = e.getWesternmostCenter();
				t_h = Location(locationGrid.get(t_p.gridX, t_p.gridY)).hub;
					
				
				//make path
				 t_path = lineToPoints(e.v0.gridPoint, e.v1.gridPoint);
				
				
				// for each point in path make location
				//first and last skipped because its already a corner					
				for (var i:int = 1; i < t_path.length - 1;i++) {
					t_loc = locationGrid.get(t_path[i].x, t_path[i].y);	
					t_loc.onEdges.push(e);
					t_loc.setHub(t_h);
					//t_loc.path = path;
					
				}
				path++;
					
								
				
				
			}
			
			
			
		}
		
		
		/**
		 * 
		 * simple line algorithm. 
		 * TODO: no diagonal lines.	
		 * 
		 * 		 
		 */		
		public static function lineToPoints(start:Point, end:Point):Vector.<Point> {
			var points:Vector.<Point> = new Vector.<Point>();
				
			var x0:int = start.x;
			var y0:int = start.y;
			var x1:int = end.x;
			var y1:int = end.y;
			
			var dx:int = Math.abs(x1 - x0);
			var dy:int = Math.abs(y1 - y0);
			
			var sx:int = 0;
			var sy:int = 0;
			
			if (x0 < x1) { sx = 1; } else { sx = -1; }
			if (y0 < y1) { sy = 1; } else { sy = -1; }
			
			var err:int = dx - dy;
			
			points.push(new Point(x0, y0));
			
			while (x0 != x1 || y0 != y1)
			{
				var e2:Number = 2 * err;
				if (e2 > -dy)
				{
					err -= dy
					x0 += sx
					points.push(new Point(x0, y0));
				}
				if (e2 <  dx)
				{
					err += dx
					y0 += sy 
					points.push(new Point(x0, y0))
				}
			}

			return points;
		}
		
		private function fillAreasAroundCenters():void {
			
			var t_loc:Location;
			
			for each (var c:Center in voimap.centers) {
				
				t_loc = locationGrid.get(c.gridX, c.gridY);
				flood_fill_areas(c.gridX, c.gridY, t_loc, t_loc.hub, true);				
				
			}
			
			
		}
		
		
		/**
		 * 
		 * uses 8-neighbors floodfill algorithm 
		 * 
		 */
		private function flood_fill_areas(x:int, y:int, loc:Location, area:Hub, first:Boolean = false):void {
			
			//var t_pos:Point;
			var res:Point;
			var t_loc:Location;
			
			
			if (loc.hub.emptyhub || first) {
				
				loc.setHub(area);
				//trace("sethub:" + loc.gridX +"-" + loc.gridY + "| c:" + area.center.gridX+"-"+area.center.gridY);
				
				res = locationGrid.getRelativePosition(x, y, 1, 0);				
				if (res != null) {				
					t_loc = locationGrid.get(res.x,res.y);
					flood_fill_areas(res.x,res.y, t_loc, area);
				}
				res = locationGrid.getRelativePosition(x, y, -1, 0);
				if (res != null) {			
					t_loc = locationGrid.get(res.x,res.y);
					flood_fill_areas(res.x,res.y, t_loc, area);
				}
				res = locationGrid.getRelativePosition(x, y, 0, 1);
				if (res != null) {				
					t_loc = locationGrid.get(res.x,res.y);
					flood_fill_areas(res.x,res.y, t_loc, area);
				}
				res = locationGrid.getRelativePosition(x, y, 0, -1);
				if (res != null) {				
					t_loc = locationGrid.get(res.x,res.y);
					flood_fill_areas(res.x,res.y, t_loc, area);
				}
				
				
				
				//diagonal
				res = locationGrid.getRelativePosition(x, y, 1, 1);
				if (res != null) {			
					t_loc = locationGrid.get(res.x,res.y);
					flood_fill_areas(res.x,res.y, t_loc, area);
				}
				res = locationGrid.getRelativePosition(x, y, -1, -1);
				if (res != null) {					
					t_loc = locationGrid.get(res.x,res.y);
					flood_fill_areas(res.x,res.y, t_loc, area);
				}
				res = locationGrid.getRelativePosition(x, y, 1, -1);
				if (res != null) {			
					t_loc = locationGrid.get(res.x,res.y);
					flood_fill_areas(res.x,res.y, t_loc, area);
				}
				res = locationGrid.getRelativePosition(x, y, -1, 1);
				if (res != null) {				
					t_loc = locationGrid.get(res.x,res.y);
					flood_fill_areas(res.x,res.y, t_loc, area);
				}
				
				
			}
		
		}
		
		
		private function createTemperatureMaps(xml:XML):void {
			
			_temperatureMaps = new Vector.<TemperatureMap>;
			// XML parsing	
			var tmaps:XMLList = xml.temperaturemap;	
			
			for (var i:int = 0; i < tmaps.length(); i++) _temperatureMaps.push(new TemperatureMap(tmaps[i]));			
			
			
		}
		
		private function createRainMaps(xml:XML):void {
			
			_rainMaps = new Vector.<RainMap>;			
			// XML parsing	
			var rmaps:XMLList = xml.rainmap;
			
			for (var i:int = 0; i < rmaps.length(); i++) _rainMaps.push(new RainMap(rmaps[i]));	
			
		}
		
		private function createEnvironments(xml:XML):void {
			
			environements = new Dictionary();
			
			// XML parsing	
			var envs:XMLList = xml.environment;
			
			
			for (var i:int = 0; i < envs.length(); i++) environements[String(envs[i].uniqueID)] = new Environment(envs[i]);	
			
			
			
			
		}
		
		private function createBiomes(xml:XML):void {
			
			biomes = new Dictionary();
			
			// XML parsing	
			var bmaps:XMLList = xml.biome;
			
			
			//add hardcoded Ocean Biome
			_oceanBiome =  new Biome();
			_oceanBiome.name = "Ocean";
			_oceanBiome.uniqueID = "ocean";			
			_oceanBiome.baseColor = 0xcbd7ff;			
			biomes[_oceanBiome.uniqueID] = _oceanBiome;
			
			
			for (var i:int = 0; i < bmaps.length(); i++) {
				
				var ui:String = String(bmaps[i].uniqueID);				
				if (ui.length > 0 && ui != _oceanBiome.uniqueID && biomes[ui] == null) biomes[ui] = new Biome(bmaps[i], environements);
				
			}
			
			
			
		}
		
		
		
		
		private function addBiomes():void {
			
			
			/*
			 * Add Biomes to centers (Oceans included) 
			 * 			 
			 * 
			 */
			
						
			var t_loc:Location;
			var t_loc_c:Location;
			
			
			for each (var cc:Center in voimap.centers) {
				
				t_loc = locationGrid.get(cc.gridX, cc.gridY);
				
				if (cc.onFrameBorder) t_loc.setBiome(_oceanBiome);						
				else t_loc.setBiome(_biomeDiagramm.getBiome(t_loc.temperature, t_loc.rain));
				
			}
			
			
			/**
			 * 
			 * Add edge types
			 * 
			 */
			for each (var e:Edge in voimap.edges) {				
				
				var d0:Location = Location(locationGrid.get(e.d0.gridX, e.d0.gridY));
				var d1:Location = Location(locationGrid.get(e.d1.gridX, e.d1.gridY));
				
				if (d0.biome == d1.biome) {
					
					if (d0.biome == _oceanBiome) {
						e.biomeEdgeType = Edge.BIOME_EDGETYPE_OCEAN;
						
					}
					else {
						e.biomeEdgeType = Edge.BIOME_EDGETYPE_INLAND_SOFTBORDER;
					}
					
				}
				else {
					if (d0.biome == _oceanBiome || d1.biome == _oceanBiome) {
						e.biomeEdgeType = Edge.BIOME_EDGETYPE_COAST;
					}
					else { 
						e.biomeEdgeType = Edge.BIOME_EDGETYPE_INLAND_HARDBORDER;
						
						//trace("hardborder at:"+e.v0.gridPoint.toString()+","+e.v1.gridPoint.toString())
					}
					
				}
				
				
				
			}
			
			
			
			/*
			 * 
			 * add rest
			 * 
			*/
			var it:Array2DIterator = Array2DIterator(locationGrid.getIterator());
			var l:Location;
			var c:Point;	
			var t_oceancount:int;
			while (it.hasNext()) {
				
				l = Location(it.next());
				
				
				if (l.biome == null) {
					
					t_loc_c = Location(locationGrid.get(l.hub.center.gridX, l.hub.center.gridY));
					l.setBiome(t_loc_c.biome);	
					
					if (l.onEdges.length > 0) { //set Location to ocean if at least one coast edge is going through
						
						for each(e in l.onEdges) {	
				
							
							if (e.biomeEdgeType == Edge.BIOME_EDGETYPE_COAST) {
								l.setBiome(_oceanBiome);
								l.isCoast = true;
								
								//set corner Locations also  to ocean								
								t_loc = Location(locationGrid.get(e.v0.gridPoint.x, e.v0.gridPoint.y));								
								if (t_loc.biome == null || t_loc.biome != _oceanBiome) t_loc.setBiome(_oceanBiome);
								
								t_loc = Location(locationGrid.get(e.v1.gridPoint.x, e.v1.gridPoint.y));								
								if (t_loc.biome == null || t_loc.biome != _oceanBiome) t_loc.setBiome(_oceanBiome);
								
							}
							
							
							
						}
						
					}
					
				}
				
				
			}
			
			
			
			
			
			
			//delete (debug)
			/*
			for each (e in voimap.edges) {
					
				var dd0:Location = Location(locationGrid.get(e.d0.gridX, e.d0.gridY));
				var dd1:Location = Location(locationGrid.get(e.d1.gridX, e.d1.gridY));
				if(dd0.biome.ground == 2 || dd1.biome.ground == 2) 
				trace("[" + e.v0.voiPoint.x+"-"+e.v0.voiPoint.y+"] [" + e.v1.voiPoint.x+"-"+e.v1.voiPoint.y+"] : [" + e.d0.gridX+"-"+e.d0.gridY+"] [" + e.d1.gridX+"-"+e.d1.gridY+"]"+ dd0.biome.name + "("+dd0.biome.ground+") ,"+ dd1.biome.name + "("+dd1.biome.ground+") ,");
			
			}
			*/
			
			
		}
		
		
		
		private function addTemperaturesAndRain():void {
			
			
			var it:Array2DIterator = Array2DIterator(locationGrid.getIterator());
			var l:Location;
			var c:Point;
			while (it.hasNext()) {				
				
				l = it.next();				
				c =  scaleGridPoint(new Point(l.hub.center.gridX, l.hub.center.gridY),TemperatureMap.WIDTH,TemperatureMap.HEIGHT);
				l.setTemperature(_temperatureMap.map.get(c.x,c.y));
				
				c =  scaleGridPoint(new Point(l.hub.center.gridX, l.hub.center.gridY),RainMap.WIDTH,RainMap.HEIGHT);
				l.setRain(_rainMap.map.get(c.x, c.y));
				
			}
			
			
			
		}
		
		private function scaleGridPoint(gridP:Point,new_width:int,new_height:int):Point {
			
			return new Point(Math.floor(gridP.x / (locationGrid.width / new_width)), Math.floor(gridP.y / (locationGrid.height / new_height)));
			
			
		}
		
		
		private function addEnvironments(random:PM_PRNG):void {
			
			
			//biome queues
			var t_b:Biome = null;
			var t_e:Environment = null;
			var t_e_q:Vector.<Environment> = null;
			var envQueues:Vector.<Vector.<Environment>> = new Vector.<Vector.<Environment>>;
			var b_l:int = DictionaryUtils.getLength(biomes);
			for (var i:int = 0; i < b_l; i++) envQueues[i] = new Vector.<Environment>;
			var dr:int;
			
			var it:Array2DIterator = Array2DIterator(locationGrid.getIterator());
			var l:Location;
			var c:Point;			
			outerLoop: while (it.hasNext()) {		
				
				l = it.next();
				
				if (l.environment == null) {
					
					
					t_e_q = envQueues[DictionaryUtils.indexOf(biomes,l.biome)];
					
					
					//put next fitting from queue
					for each(t_e in t_e_q) {
						
						if (fitEnvironment(l, t_e)) {
							t_e_q.splice(t_e_q.indexOf(t_e), 1); //remove item from queue
							continue outerLoop;
						}
						
					}
					
					
					//if queue empty or none fits, dice
					dr = DropRateCalculators.PercentageLottery(l.biome.environments_dropRates, random);
					if (dr >= 0 && l.biome.environments[dr] != null) {
						
						
						t_e = l.biome.environments[dr];
						if (fitEnvironment(l, t_e)) continue outerLoop;
						else {	
							
							//add to queue
							if (t_e_q.indexOf(t_e) < 0) t_e_q.push(t_e);
							//and dice 2nd time
							dr = DropRateCalculators.PercentageLottery(l.biome.environments_dropRates, random);
							//and add if fits
							if (dr >= 0 && l.biome.environments[dr] != null) fitEnvironment(l, l.biome.environments[dr]); 
							
							
							
						}
						
						
						
					}
					
					
					
					
				}
				
			}
			
		}
		
		private function fitEnvironment(loc:Location,env:Environment):Boolean {
			
			var res:Point;
			var t_loc:Location = null;
			var locs:Vector.<Location> = new Vector.<Location>;
			var p:Point;
			
			//v1 brute force
			//v2 idea: u could check from 2 sides for less steps)
			for each(p in env.sprUsedTiles) {
				
				res = locationGrid.getRelativePosition(loc.gridX, loc.gridY, p.x - env.sprOriginTile.x, p.y - env.sprOriginTile.y);				
				if (res != null) {
					t_loc = Location(locationGrid.get(res.x, res.y));
					if (t_loc.environment == null && t_loc.biome == loc.biome) locs.push(t_loc);
					else break;
					
				}
				
			}
				
			
			if (locs.length == env.sprUsedTiles.length) {
				for each(t_loc in locs) t_loc.environment = env;
				return true;
			}
			else return false;
			
			
		}
		
		
		
		
		
		
		
	}

}