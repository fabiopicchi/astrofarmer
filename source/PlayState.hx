package;

import haxe.io.Path;
import haxe.Json;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxGroup;
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
    private var bulletPool:List<Bullet>;
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

    private function createBullet(x:Float, y:Float, angle:Float):Void
    {
        var b:Bullet;
        if(bulletPool.isEmpty()) b = new Bullet();
        else b = bulletPool.pop();

        b.set(x, y, angle);
        b.destroySignal.add(destroyBullet);
        add(b);
    }

    private function destroyBullet(b:Bullet):Void
    {
        remove(b);
        bulletPool.push(b);
    }

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        bulletPool = new List<Bullet>();

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
                        player.shootingSignal.add(createBullet);
                        add(player);
                }
            }
        }
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
    }	
}
