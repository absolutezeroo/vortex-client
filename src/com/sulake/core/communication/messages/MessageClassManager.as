package com.sulake.core.communication.messages
{
    import flash.utils.Dictionary;
    import com.sulake.core.utils.ClassUtils;
    import flash.utils.getQualifiedClassName;

        public class MessageClassManager
    {

        private var _messageIdByComposerClass:Dictionary = new Dictionary();
        private var _messageIdByEventClass:Dictionary = new Dictionary();
        private var _messageInstancesById:Dictionary = new Dictionary();

        public function dispose():void
        {
            var _local_1:IMessageEvent;

            if (_messageInstancesById)
            {
                for each (var _local_2:Object in _messageInstancesById)
                {
                    _local_1 = _messageInstancesById[_local_2];

                    if (_local_1)
                    {
                        _local_1.dispose();
                    };
                };
            };
        }

        public function registerMessages(messageConfiguration:IMessageConfiguration):void
        {
            var _local_2:String;

            for (_local_2 in messageConfiguration.events)
            {
                registerMessageEventClass(parseInt(_local_2), messageConfiguration.events[_local_2]);
            };

            for (_local_2 in messageConfiguration.composers)
            {
                registerMessageComposerClass(parseInt(_local_2), messageConfiguration.composers[_local_2]);
            };
        }

        private function registerMessageComposerClass(messageID:int, composerClass:Class):void
        {
            if (!ClassUtils.implementsInterface(composerClass, IMessageComposer))
            {
                throw (new Error(("Invalid composer class for message ID " + messageID)));
            };

            var _local_3:String = getQualifiedClassName(composerClass);

            if (_messageIdByComposerClass[_local_3] != null)
            {
                throw (new Error(("Duplicate message ID definition for composer class " + _local_3)));
            };

            _messageIdByComposerClass[_local_3] = messageID;
        }

        private function registerMessageEventClass(messageId:int, eventClass:Class):void
        {
            if (!ClassUtils.implementsInterface(eventClass, IMessageEvent))
            {
                throw (new Error(("Invalid event class for message ID " + messageId)));
            };

            var _local_3:String = getQualifiedClassName(eventClass);

            if (_messageIdByEventClass[_local_3] != null)
            {
                throw (new Error(("Duplicate message ID definition for event class " + _local_3)));
            };

            _messageIdByEventClass[_local_3] = messageId;
        }

        public function registerMessageEvent(event:IMessageEvent):void
        {
            var _local_4:String = getQualifiedClassName(event);
            var _local_2:Object = _messageIdByEventClass[_local_4];

            if (_local_2 == null)
            {
                throw (new Error(("Unknown message event class " + _local_4)));
            };

            var _local_3:Array = _messageInstancesById[_local_2];

            if (_local_3 != null)
            {
                event.parser = (_local_3[0] as IMessageEvent).parser;
            }

            else
            {
                _local_3 = [];
                _messageInstancesById[_local_2] = _local_3;
                event.parser = new event.parserClass();
            };

            _local_3.push(event);
        }

        public function unregisterMessageEvent(event:IMessageEvent):void
        {
            var _local_5:String = getQualifiedClassName(event);
            var _local_2:Object = _messageIdByEventClass[_local_5];

            if (_local_2 == null)
            {
                return;
            };

            var _local_4:Array = _messageInstancesById[_local_2];

            if (_local_4 == null)
            {
                return;
            };

            var _local_3:int = _local_4.indexOf(event);

            if (_local_3 >= 0)
            {
                _local_4.splice(_local_3, 1);

                if (_local_4.length == 0)
                {
                    delete _messageInstancesById[_local_2];
                };
            };
        }

        public function getMessageIDForComposer(composer:IMessageComposer):int
        {
            var _local_2:Object = _messageIdByComposerClass[getQualifiedClassName(composer)];

            if (_local_2 == null)
            {
                return (-1);
            };

            return int((_local_2));
        }

        public function getMessageEventsForID(id:int):Array
        {
            return (_messageInstancesById[id]);
        }

    }
}