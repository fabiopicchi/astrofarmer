import flixel.FlxObject;
import flixel.FlxG;

class FlxSlope extends FlxObject
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
    }
	
	public static function separateSlopeX(Object1:FlxObject, Object2:FlxObject):Bool
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
        else 
		{
			return false;
		}
		
		if ((slope.type == "left" && (obj.last.x + obj.width <= slope.x)) ||
			(slope.type == "right" && (obj.last.x >= slope.x + slope.width)))
		{
			return FlxObject.separateX(Object1, Object2);
		}
		else
		{
			return false;
		}
	}

    public static function separateSlopeY(Object1:FlxObject, Object2:FlxObject):Bool
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
        else
		{
			return false;
		}
		
		if (obj.last.y + obj.height > slope.y + slope.height)
		{
			return FlxObject.separateY(Object1, Object2);
		}
		else
		{
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
				return true;
			}
			else
			{
				return false;
			}
		}
    }
	
	public static function separateSlope(Object1:FlxObject, Object2:FlxObject):Bool
	{
		return FlxSlope.separateSlopeX(Object1, Object2) || FlxSlope.separateSlopeY(Object1, Object2);
	}
}
