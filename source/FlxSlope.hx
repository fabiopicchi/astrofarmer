import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;

class FlxSlope extends FlxSprite
{
    private var type:String;

    public function new(Type:String, X:Float = 0, Y:Float = 0, Width:Float = 0, Height:Float = 0)
    {
        super(X, Y);

        width = Width;
        height = Height;
        type = Type;
        immovable = true;
        moves = false;

        makeGraphic(Std.int(width), Std.int(height), 0xFF00FF00);
    }

    public static function separateYSlope(Object1:FlxObject, Object2:FlxObject):Void
    {
        var slope:FlxSlope;
        var obj:FlxObject;
        if(Std.is(Object1, FlxSlope))
        {
            slope = cast(Object1, FlxSlope);
            obj = Object2;
        }
        else if(Std.is(Object2, FlxSlope))
        {
            slope = cast(Object2, FlxSlope);
            obj = Object1;
        }
        else return;

        var targetY = slope.y + slope.height - obj.height;

        if(slope.type == "left")
        {
            targetY -= Math.min(((slope.x + slope.width - obj.x) / slope.width) * slope.height, slope.height);
        }
        else if(slope.type == "right")
        {
            targetY -= Math.min(((obj.x + obj.width - slope.x) / slope.width) * slope.height, slope.height);
        }

        if(obj.y > targetY) 
        {
            obj.y = targetY;
            obj.velocity.y = 0;
            obj.touching |= FlxObject.DOWN;
            slope.touching |= FlxObject.UP;
        }
    }
}
