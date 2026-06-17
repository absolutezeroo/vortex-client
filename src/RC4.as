package
{
   import flash.utils.ByteArray;

   public class RC4
   {

      private const _stateSize:uint = 0x0100;

      private var i:int = 0;
      private var _j:int = 0;
      private var _state:ByteArray;

      public function RC4(seed:ByteArray = null)
      {
         super();
         this._state = new ByteArray();

         if(seed)
         {
            this.initialize(seed);
         }
      }

      public function getStateSize() : uint
      {
         return this._stateSize;
      }

      public function initialize(key:ByteArray) : void
      {
         var _local_2:int = 0;
         var _local_3:int = 0;
         var _local_4:int = 0;
         _local_2 = 0;

         while(_local_2 < 0x0100)
         {
            this._state[_local_2] = _local_2;
            _local_2++;
         }

         _local_3 = 0;
         _local_2 = 0;

         while(_local_2 < 0x0100)
         {
            _local_3 = _local_3 + this._state[_local_2] + key[_local_2 % key.length] & 0xFF;
            _local_4 = this._state[_local_2];
            this._state[_local_2] = this._state[_local_3];
            this._state[_local_3] = _local_4;
            _local_2++;
         }

         this.i = 0;
         this._j = 0;
      }

      private function getKeyStreamByte() : uint
      {
         var _local_1:int = 0;
         this.i = this.i + 1 & 0xFF;
         this._j = this._j + this._state[this.i] & 0xFF;
         _local_1 = this._state[this.i];
         this._state[this.i] = this._state[this._j];
         this._state[this._j] = _local_1;
         return this._state[_local_1 + this._state[this.i] & 0xFF];
      }

      public function getVersion() : uint
      {
         return 1;
      }

      public function transform(data:ByteArray) : void
      {
         var _local_2:uint = 0;

         while(_local_2 < data.length)
         {
            var _local_3:int = _local_2++;
            data[_local_3] ^= this.getKeyStreamByte();
         }
      }

      public function decrypt(data:ByteArray) : void
      {
         this.transform(data);
      }

      public function dispose() : void
      {
         var _local_1:uint = 0;

         if(this._state != null)
         {
            _local_1 = 0;

            while(_local_1 < this._state.length)
            {
               this._state[_local_1] = Math.random() * 0x0100;
               _local_1++;
            }

            this._state.length = 0;
            this._state = null;
         }

         this.i = 0;
         this._j = 0;
      }
   }
}
