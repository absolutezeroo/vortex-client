package com.sulake.bootstrap
{
    import com.sulake.habbo.friendlist.HabboFriendList;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboFriendListBootstrap extends HabboFriendList 
    {

        public function HabboFriendListBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}