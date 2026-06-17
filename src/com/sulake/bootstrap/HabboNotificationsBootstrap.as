package com.sulake.bootstrap
{
    import com.sulake.habbo.notifications.HabboNotifications;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboNotificationsBootstrap extends HabboNotifications 
    {

        public function HabboNotificationsBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}