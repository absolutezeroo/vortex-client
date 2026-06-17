package com.sulake.room.renderer {
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IContext;

    public class RoomRendererFactory extends Component implements IRoomRendererFactory {

        public function RoomRendererFactory(context:IContext, id:uint = 0) {
            super(context, id);
        }

        public function createRenderer():IRoomRenderer {
            return (new RoomRenderer(this));
        }

    }
}
