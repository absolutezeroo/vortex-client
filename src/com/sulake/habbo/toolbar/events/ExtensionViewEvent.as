package com.sulake.habbo.toolbar.events
{
    import flash.events.Event;

    public class ExtensionViewEvent extends Event 
    {

        public static const _SafeStr_3768:String = "EVE_EXTENSION_VIEW_RESIZED";

        public function ExtensionViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }

    }
}
