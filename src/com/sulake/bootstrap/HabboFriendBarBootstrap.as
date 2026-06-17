package com.sulake.bootstrap
{
    import com.sulake.habbo.friendbar.HabboFriendBar;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboFriendBarBootstrap extends HabboFriendBar 
    {

        public function HabboFriendBarBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}