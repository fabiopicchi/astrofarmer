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
	private inline static var STAGE_PATH:String = "assets/data/sample-stage.tmx";
    private inline static var TILESET_PATH:String = "assets/images/";
	
    private var playerCollision:FlxGroup;
    private var slopeCollision:FlxGroup;
    private var bulletPool:List<Bullet>;
    private var player:Player;
    private var obj1:FlxObject;
    private var obj2:FlxObject;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        bulletPool = new List<Bullet>();

        playerCollision = new FlxGroup();
        slopeCollision = new FlxGroup();

        var map:TiledMap = new TiledMap(STAGE_PATH);
		var tileSet:TiledTileSet;
        for (ts in map.tilesets)
        {
            tileSet = ts;
            break;
        }
        for(l in map.layers)
        {
            var tilemap:FlxTilemap = loadTilemapLayer(l, tileSet);
            add(tilemap);
            if (l.properties.contains("collidable")) 
			{
				playerCollision.add(tilemap);
				for (i in 0...tileSet.tileProps.length)
				{
					var p = tileSet.tileProps[i];
					if (p != null && p.contains("type"))
					{
						var type = p.get("type");
						switch(type)
						{
							case "slope-left" | "slope-right":
								tilemap.setTileProperties((i + 1), FlxObject.NONE);
								var slopes = tilemap.getTileCoords((i + 1), false);
								var slope:FlxSlope;
								for (i in 0...slopes.length)
								{
									slope = new FlxSlope(type.split("-")[1], slopes[i].x, slopes[i].y, map.tileWidth, map.tileHeight);
									slopeCollision.add(slope);
									add(slope);
								}
						}
					}
				}
			}
        }

        var obj:FlxObject;
        for(group in map.objectGroups)
        {
            for(object in group.objects)
            {
                switch(object.custom.get("type"))
                {
                    case "player":
                        player = new Player(object);
                        player.shootingSignal.add(createBullet);
                    case "slope-left":
                        obj = new FlxSlope("left", object.x, object.y, object.width, object.height);
                        slopeCollision.add(obj);
                        add(obj);
                    case "slope-right":
                        obj = new FlxSlope("right", object.x, object.y, object.width, object.height);
                        slopeCollision.add(obj);
                        add(obj);
                }
            }
        }
        add(player);
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
		FlxG.overlap(slopeCollision, player, FlxSlope.separateSlopeX);
        FlxG.collide(playerCollision, player);
		FlxG.overlap(slopeCollision, player, FlxSlope.separateSlopeY);
    }	

    private function loadTilemapLayer(tileLayer:TiledLayer, tileSet:TiledTileSet):FlxTilemap
    {
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
}
