import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.util.FlxDestroyUtil;
import flixel.addons.editors.tiled.TiledObject;

class Player extends FlxSprite
{
    private var jumpSpeed:Float;
    private var jumpHeight:Float;
    private var gravity:Float;
    private var speed:Float;
    private var shootingInterval:Float;
    private var shootingCooldown:Float;

    public var shootingSignal:FlxTypedSignal<Float->Float->Float->Void>;

    public function new(data:TiledObject)
    {
        super(data.x,data.y);
        width = data.width;
        height = data.height;
        makeGraphic(Std.int(width), Std.int(height), 0xFFFF0000);

        gravity = Std.parseInt(data.custom.get("gravity"));
        jumpHeight = Std.parseInt(data.custom.get("jump-height"));
        speed = Std.parseInt(data.custom.get("speed"));

        acceleration.y = gravity;
        jumpSpeed = Math.sqrt(2 * gravity * jumpHeight);

        shootingInterval = 0.1;
        shootingCooldown = 0;
        shootingSignal = new FlxTypedSignal<Float->Float->Float->Void>();
    }

    override public function update():Void
    {
        if(FlxG.keys.pressed.D) velocity.x = speed;
        else if(FlxG.keys.pressed.A) velocity.x = -speed;
        else velocity.x = 0;

        if(FlxG.keys.justPressed.W && isTouching(FlxObject.FLOOR)) velocity.y = -jumpSpeed;

        if(shootingCooldown == 0 && FlxG.mouse.pressed) 
        {
            shootingCooldown = shootingInterval;
            shootingSignal.dispatch(
                x + width/2, 
                y + height/2,
                Math.atan2(FlxG.mouse.y - y, FlxG.mouse.x - x));
        }

        if(shootingCooldown > 0) shootingCooldown -= FlxG.elapsed;
        else shootingCooldown = 0;
        
        super.update();
    }

    override public function destroy():Void
    {
        FlxDestroyUtil.destroy(shootingSignal);
        super.destroy();
    }
}
