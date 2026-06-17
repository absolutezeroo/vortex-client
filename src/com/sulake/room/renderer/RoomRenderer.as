package com.sulake.room.renderer {
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.Component;
    import com.sulake.room.object.IRoomObject;
    import flash.utils.getTimer;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.room.utils.RoomGeometry;

    public class RoomRenderer implements IRoomRenderer, IRoomSpriteCanvasContainer {

        private var _objects:Map;
        private var _canvases:Map;
        private var _component:Component;
        private var _disposed:Boolean = false;
        private var _roomObjectVariableAccurateZ:String = null;

        public function RoomRenderer(component:Component) {
            _objects = new Map();
            _canvases = new Map();

            if (component != null) {
                _component = component;
            }
            ;
        }

        public function get disposed():Boolean {
            return (_disposed);
        }

        public function get roomObjectVariableAccurateZ():String {
            return (_roomObjectVariableAccurateZ);
        }

        public function set roomObjectVariableAccurateZ(variableName:String):void {
            _roomObjectVariableAccurateZ = variableName;
        }

        public function dispose():void {
            var _index:int;
            var _canvas:RoomSpriteCanvas;

            if (disposed) {
                return;
            }
            ;

            if (_canvases != null) {
                _index = 0;

                while (_index < _canvases.length) {
                    _canvas = (_canvases.getWithIndex(_index) as RoomSpriteCanvas);

                    if (_canvas != null) {
                        _canvas.dispose();
                    }
                    ;

                    _index++;
                }
                ;

                _canvases.dispose();
                _canvases = null;
            }
            ;

            if (_objects != null) {
                _objects.dispose();
                _objects = null;
            }
            ;

            if (_component != null) {
                _component = null;
            }
            ;

            _disposed = true;
        }

        public function reset():void {
            _objects.reset();
        }

        public function getRoomObjectIdentifier(roomObject:IRoomObject):String {
            if (roomObject != null) {
                return String((roomObject.getInstanceId()));
            }
            ;

            return (null);
        }

        public function feedRoomObject(roomObject:IRoomObject):void {
            if (roomObject == null) {
                return;
            }
            ;

            _objects.add(getRoomObjectIdentifier(roomObject), roomObject);
        }

        public function removeRoomObject(roomObject:IRoomObject):void {
            var _index:int;
            var _canvas:RoomSpriteCanvas;
            var _roomObjectId:String = getRoomObjectIdentifier(roomObject);
            _objects.remove(_roomObjectId);
            _index = 0;

            while (_index < _canvases.length) {
                _canvas = (_canvases.getWithIndex(_index) as RoomSpriteCanvas);

                if (_canvas != null) {
                    _canvas.roomObjectRemoved(_roomObjectId);
                }
                ;

                _index++;
            }
            ;
        }

        public function getRoomObject(roomObjectId:String):IRoomObject {
            return (_objects.getValue(roomObjectId) as IRoomObject);
        }

        public function getRoomObjectWithIndex(index:int):IRoomObject {
            return (_objects.getWithIndex(index) as IRoomObject);
        }

        public function getRoomObjectIdWithIndex(index:int):String {
            return (_objects.getKey(index) as String);
        }

        public function getRoomObjectCount():int {
            return (_objects.length);
        }

        public function render():void {
            var _index:int;
            var _canvas:IRoomRenderingCanvas;
            var _timestamp:int = getTimer();
            ErrorReportStorage.addDebugData("Canvas count", String(_canvases.length));
            _index = (_canvases.length - 1);

            while (_index >= 0) {
                _canvas = (_canvases.getWithIndex(_index) as IRoomRenderingCanvas);

                if (_canvas != null) {
                    _canvas.render(_timestamp);
                }
                ;

                _index--;
            }
            ;
        }

        public function createCanvas(canvasId:int, width:int, height:int, scale:int):IRoomRenderingCanvas {
            var _geometry:RoomGeometry;
            var _canvas:IRoomRenderingCanvas = (_canvases.getValue(String(canvasId)) as IRoomRenderingCanvas);

            if (_canvas != null) {
                _canvas.initialize(width, height);
                _geometry = (_canvas.geometry as RoomGeometry);

                if (_geometry) {
                    _geometry.scale = scale;
                }
                ;

                return (_canvas);
            }
            ;

            _canvas = createCanvasInstance(canvasId, width, height, scale);
            _canvases.add(String(canvasId), _canvas);
            return (_canvas);
        }

        protected function createCanvasInstance(canvasId:int, width:int, height:int, scale:int):IRoomRenderingCanvas {
            return (new RotatingRoomSpriteCanvas(this, canvasId, width, height, scale));
        }

        public function getCanvas(canvasId:int):IRoomRenderingCanvas {
            return (_canvases.getValue(String(canvasId)) as IRoomRenderingCanvas);
        }

        public function disposeCanvas(canvasId:int):Boolean {
            var _canvas:RoomSpriteCanvas = (_canvases.remove(String(canvasId)) as RoomSpriteCanvas);

            if (_canvas != null) {
                _canvas.dispose();
            }
            ;

            return (false);
        }

        public function update(timestamp:uint):void {
            var _index:int;
            var _canvas:RoomSpriteCanvas;
            render();
            _index = (_canvases.length - 1);

            while (_index >= 0) {
                _canvas = (_canvases.getWithIndex(_index) as RoomSpriteCanvas);

                if (_canvas != null) {
                    _canvas.update();
                }
                ;

                _index--;
            }
            ;
        }

    }
}
