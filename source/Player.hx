import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledObject;

class Player extends FlxSprite
{
    private var jumpSpeed:Float;
    private var jumpHeight:Float;
    private var gravity:Float;

    public function new(data:TiledObject)
    {
        super(data.x,data.y);
        width = data.width;
        height = data.height;
        makeGraphic(Std.int(width), Std.int(height), 0xFFFF0000);

        gravity = Std.parseInt(data.custom.get("gravity"));
        jumpHeight = Std.parseInt(data.custom.get("jump-height"));

        acceleration.y = gravity;
        jumpSpeed = Math.sqrt(2 * gravity * jumpHeight);
    }

    override public function update():Void
    {
        if(FlxG.keys.pressed.RIGHT) velocity.x = 100;
        else if(FlxG.keys.pressed.LEFT) velocity.x = -100;
        else velocity.x = 0;

        if(FlxG.keys.justPressed.UP && isTouching(FlxObject.FLOOR)) velocity.y = -jumpSpeed;
        super.update();
    }
}
