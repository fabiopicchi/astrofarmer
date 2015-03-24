import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSignal;
import flixel.util.FlxDestroyUtil;

class Bullet extends FlxSprite
{
    public var destroySignal:FlxTypedSignal<Bullet->Void>;

    public function new():Void
    {
        super();
        width = 4;
        height = 4;
        makeGraphic(Std.int(width), Std.int(height), 0xFFFF0000);
        destroySignal = new FlxTypedSignal<Bullet->Void>();
    }

    public function set(x:Float, y:Float, angle:Float):Void
    {
        this.x = x - width/2;
        this.y = y - height/2;
        velocity.x = 500 * Math.cos(angle);
        velocity.y = 500 * Math.sin(angle);

        destroySignal.removeAll();
    }

    override public function update():Void
    {
        super.update();
        if(!this.isOnScreen(FlxG.camera)) 
            destroySignal.dispatch(this);
    }

    override public function destroy():Void
    {
        FlxDestroyUtil.destroy(destroySignal);
        super.destroy();
    }
}
