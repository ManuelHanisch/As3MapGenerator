

![Preview Image](https://github.com/ManuelHanisch/As3MapGenerator/blob/master/gh_preview.jpg)

## A MapGenerator written in Actionscript 3. 
This is the Map-Generation module for a hobby-project i am working on. 

#### Features: 
Map Generation is based on [Voronoi Diagrams (Wikipedia)](https://en.wikipedia.org/wiki/Voronoi_diagram)

Supports XML-based Temperature- and Humidity-maps (aka Rain-maps).

Supports XML-based Biomes that are generated depending on temperature & rain/humidity.

Supports XML-based Environments (forests, Hills, Mountains or whatever you can imagine).

You can define which Environments your Biomes contain and their frequency of occurence.
You can also define custom shapes and sizes for your Environments.   

The example code (to demonstrate the generator) uses simple graphical functions, Environments are just hardcoded Draw-calls.
The XML files already support images, but uploading & implementing images or tilesets would go beyond the scope of this project.


#### Dependencies
[https://github.com/ManuelHanisch/As3Utils](https://github.com/ManuelHanisch/As3Utils)

#### References 
Many thanks to:

AmitP for this article: ["Polygonal Map Generation for Games"](http://www-cs-students.stanford.edu/~amitp/game-programming/polygon-map-generation/)
which inspired me to use Voronoi Diagrams as a solution.

Nodename for the basecode to generate Voronoi Diagrams [as3delaunay](http://nodename.github.io/as3delaunay/).
  



