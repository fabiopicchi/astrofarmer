package;

import haxe.io.Path;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileSet;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
    private var map:TiledMap;
    private inline static var TILESET_PATH:String = "assets/images/";

    private function loadTilemapLayer(mapData:TiledMap, tileLayer:TiledLayer):FlxTilemap
    {
        var tileSheetName:String = tileLayer.properties.get("tileset");
        var tileSet:TiledTileSet = null;
        if (tileSheetName == null)
            throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
        for (ts in mapData.tilesets)
        {
            if (ts.name == tileSheetName)
            {
                tileSet = ts;
                break;
            }
        }
        if (tileSet == null)
            throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
        var imagePath = new Path(tileSet.imageSource);
        var processedPath = TILESET_PATH + imagePath.file + "." + imagePath.ext;
        var tilemap:FlxTilemap = new FlxTilemap();
        tilemap.widthInTiles = mapData.width;
        tilemap.heightInTiles = mapData.height;
        tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
        return tilemap;
    }

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        var map:TiledMap = new TiledMap("assets/data/sample-stage.tmx");
        for(l in map.layers) add(loadTilemapLayer(map, l));
    }

    /**
     * Function that is called when this state is destroyed - you might want to 
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void
    {
        super.destroy();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void
    {
        super.update();
    }	
}
