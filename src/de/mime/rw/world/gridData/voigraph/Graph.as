package de.mime.rw.world.gridData.voigraph 
{
	
	import com.nodename.Delaunay.Voronoi;
	import com.nodename.geom.LineSegment;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import de.mime.rw.world.gridData.voigraph.Edge;
	import de.mime.rw.world.gridData.voigraph.Center;
	import de.mime.rw.world.gridData.voigraph.Corner;
	
	/**
	 * ...
	 * @author Manuel Hanisch
	 */
	public class Graph 
	{		
		
		public var centers:Vector.<Center>;
		public var corners:Vector.<Corner>;
		public var edges:Vector.<Edge>;
	
		private var _rectangle:Rectangle;
	
		
		public function Graph(points:Vector.<Point>, rectangle:Rectangle) 
		{
			
						
			this.edges = new Vector.<Edge>();
			this.centers = new Vector.<Center>();
			this.corners = new Vector.<Corner>();
			
			_rectangle = rectangle;	
			
			
			var voronoi:Voronoi = new Voronoi(points, null, new Rectangle(0,0,_rectangle.width -1,_rectangle.height - 1));
			buildGraph(points, voronoi);
			
			
			
			//improveCorners();			
			voronoi.dispose();
			voronoi = null;
			
		}
		
		
		public function buildGraph(points:Vector.<Point>, voronoi:Voronoi):void {
			
				
			var t_ce:Center, t_co:Corner, point:Point;	
			var libedges:Vector.<com.nodename.Delaunay.Edge> = voronoi.edges();
			var centerLookup:Dictionary = new Dictionary();	
			var cornerLookup:Dictionary = new Dictionary();
			
			
			// Build Center objects for each of the points, and a lookup map
			// to find those Center objects again as we build the graph
			for each (point in points) {
				t_ce = new Center();
				t_ce.gridX = point.x;
				t_ce.gridY = point.y;				
				
				centers.push(t_ce);
				centerLookup[point] = t_ce;
				
			}
			
			
			
			//Debug
			/*
			var megav:Dictionary = new Dictionary;	
			*/
			for each (var libedge:com.nodename.Delaunay.Edge in libedges) {
				
				var dedge:LineSegment = libedge.delaunayLine();
				var vedge:LineSegment = libedge.voronoiEdge();	
				
				
				if (vedge.p0 != null && vedge.p1 != null) {
					
					
					
					var dec:int = 12; // need to cut because points round up and dont match anymore.
					vedge.p0 = new Point(Number(vedge.p0.x.toFixed(dec)),Number(vedge.p0.y.toFixed(dec)));
					vedge.p1 = new Point(Number(vedge.p1.x.toFixed(dec)), Number(vedge.p1.y.toFixed(dec)));
					
					
					var edge:Edge = new Edge();	
					
					//edge.voiMidPoint = Point.interpolate(vedge.p0, vedge.p1, 0.5);
									
					edge.d0 = centerLookup[dedge.p0];
					edge.d1 = centerLookup[dedge.p1];					
					
					if (cornerLookup[vedge.p0] == null) edge.v0 = makeCorner(vedge.p0);
					else edge.v0 = cornerLookup[vedge.p0];
					
					if (cornerLookup[vedge.p1] == null) edge.v1 = makeCorner(vedge.p1);
					else edge.v1 = cornerLookup[vedge.p1];
					
					
					if (edge.v0.border || edge.v1.border) {
						edge.d0.onFrameBorder = true;
						edge.d1.onFrameBorder = true;
						
					}
					
					
					// Centers point to edges. Corners point to edges.
					edge.d0.borders.push(edge);
					edge.d1.borders.push(edge);
					edge.v0.protrudes.push(edge);
					edge.v1.protrudes.push(edge);					
					
					// Centers point to centers.
					if (edge.d0.neighbors.indexOf(edge.d1) < 0) edge.d0.neighbors.push(edge.d1);
					if (edge.d1.neighbors.indexOf(edge.d0) < 0) edge.d1.neighbors.push(edge.d0);
					
					// Corners point to corners					
					if (edge.v0.adjacent.indexOf(edge.v1) < 0) edge.v0.adjacent.push(edge.v1);
					if (edge.v1.adjacent.indexOf(edge.v0) < 0) edge.v1.adjacent.push(edge.v0);
					
					// Centers point to corners
					if (edge.d0.corners.indexOf(edge.v0) < 0) edge.d0.corners.push(edge.v0);
					if (edge.d0.corners.indexOf(edge.v1) < 0) edge.d0.corners.push(edge.v1);
					if (edge.d1.corners.indexOf(edge.v0) < 0) edge.d1.corners.push(edge.v0);
					if (edge.d1.corners.indexOf(edge.v1) < 0) edge.d1.corners.push(edge.v1);
					
					// Corners point to centers
					if (edge.v0.touches.indexOf(edge.d0) < 0) edge.v0.touches.push(edge.d0);
					if (edge.v0.touches.indexOf(edge.d1) < 0) edge.v0.touches.push(edge.d1);					
					if (edge.v1.touches.indexOf(edge.d0) < 0) edge.v1.touches.push(edge.d0);
					if (edge.v1.touches.indexOf(edge.d1) < 0) edge.v1.touches.push(edge.d1);
										
					edges.push(edge);
					
					
					
					
				
					// Debug
					/* 
					var pp0:Point = new Point(Number(vedge.p0.x.toFixed(dec)),Number(vedge.p0.y.toFixed(dec)));
					var pp1:Point = new Point(Number(vedge.p1.x.toFixed(dec)), Number(vedge.p1.y.toFixed(dec)));
					
					trace(pp0.toString() +"-"+ pp1.toString());
					
					if (megav[pp0.toString()] == null)  megav[pp0.toString()] = 1;
					else megav[pp0.toString()] += 1;
					
					if (megav[pp1.toString()] == null)  megav[pp1.toString()] = 1;
					else megav[pp1.toString()] += 1;
					*/
					
					
					
					
					
					
					
					
				}
				
				
			}
			
			//Debug:  Every Key (Corner) should have either 1 edge (for border) or 3 Edges (Standard) or 6 if a lot of centers make 2 edges very close to each other
			/*
			for(var key:String in megav) {
				trace(key +":"+ megav[key]);
			}
			*/			
			
			
			
				
		}
		
		
		private function makeCorner(p:Point):Corner {
			
			var t_co:Corner = new Corner();		
			
			
			t_co.voiPoint = p; //the important one for under the surface :)		
			t_co.gridPoint = new Point(Math.round(t_co.voiPoint.x), Math.round(t_co.voiPoint.y));
			
			
			t_co.border = (t_co.voiPoint.x == 0 || t_co.voiPoint.x >= (_rectangle.width - 1) || t_co.voiPoint.y == 0 || t_co.voiPoint.y >= (_rectangle.height - 1));
			
			t_co.touches = new Vector.<Center>();
			t_co.protrudes = new Vector.<Edge>();
			t_co.adjacent = new Vector.<Corner>();
			
			this.corners.push(t_co);
			
			return t_co;
			
		}
		
		
	
		
		
			
		
		
		
	}

}