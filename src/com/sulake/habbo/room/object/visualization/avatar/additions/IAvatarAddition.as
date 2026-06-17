package com.sulake.habbo.room.object.visualization.avatar.additions
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

    public /*dynamic*/ interface IAvatarAddition extends IDisposable 
    {

        function get id():int;
        function update(sprite:IRoomObjectSprite, scale:Number):void;
        function animate(sprite:IRoomObjectSprite):Boolean;

    }
}