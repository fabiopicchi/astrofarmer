package;

import haxe.io.Path;
import haxe.Json;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
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
    private var playerCollision:FlxGroup;
    private var player:Player;

    private function loadTilemapLayer(tileLayer:TiledLayer):FlxTilemap
    {
        var tileSet:TiledTileSet = null;
        for (ts in tileLayer.map.tilesets)
        {
            tileSet = ts;
            break;
        }
        var imagePath = new Path(tileSet.imageSource);
        var processedPath = TILESET_PATH + imagePath.file + "." + imagePath.ext;
        var tilemap:FlxTilemap = new FlxTilemap();
        tilemap.widthInTiles = tileLayer.map.width;
        tilemap.heightInTiles = tileLayer.map.height;
        tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
        return tilemap;
    }

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        playerCollision = new FlxGroup();

        var map:TiledMap = new TiledMap("assets/data/sample-stage.tmx");
        for(l in map.layers)
        {
            var tilemap:FlxTilemap = loadTilemapLayer(l);
            add(tilemap);
            if(l.properties.contains("collidable")) playerCollision.add(tilemap);
        }

        for(group in map.objectGroups)
        {
            for(object in group.objects)
            {
                switch(object.custom.get("name"))
                {
                    case "player":
                        player = new Player(object);
                        add(player);
                }
            }
        }

        FlxG.worldBounds.set(0, 0, map.fullWidth, map.fullHeight);
        FlxG.camera.setBounds(0, 0, map.fullWidth, map.fullHeight);

        //FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER, 100);

        //var obj:FlxSprite = new FlxSprite();
        //obj.makeGraphic(Std.int(FlxG.camera.deadzone.width), Std.int(FlxG.camera.deadzone.height), 0x66FF0000);
        //obj.x = FlxG.camera.deadzone.x;
        //obj.y = FlxG.camera.deadzone.y;
        //obj.scrollFactor.set(0,0);
        //add(obj);
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
        FlxG.collide(playerCollision, player);
        FlxG.camera.focusOn(new FlxPoint(player.x + (FlxG.mouse.x - player.x) / 10, 
                    player.y + (FlxG.mouse.y - player.y) / 10));
    }	
}
