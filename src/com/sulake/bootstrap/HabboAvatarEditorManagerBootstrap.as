package com.sulake.bootstrap
{
    import com.sulake.habbo.avatar.HabboAvatarEditorManager;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboAvatarEditorManagerBootstrap extends HabboAvatarEditorManager 
    {

        public function HabboAvatarEditorManagerBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}