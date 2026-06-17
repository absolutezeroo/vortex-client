package com.sulake.bootstrap
{
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboUserDefinedRoomEventsBootstrap extends HabboUserDefinedRoomEvents 
    {

        public function HabboUserDefinedRoomEventsBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}