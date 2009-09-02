package org.wvxvws.encoding
{
    import flash.utils.ByteArray;
    
	/**
	 * @author Clement Wong 
	 * <a href="http://stopcoding.wordpress.com/">http://stopcoding.wordpress.com/</a>
	 * @author lordofduct 
	 * <a href="http://www.lordofduct.com/">http://www.lordofduct.com/</a>
	 */
    public class ByteStreamEncoder
    {
        private var _bitPos:int = 8;
        private var _currentBlock:int = 0;
        private var _blocks:Array = [];
        
        public function ByteStreamEncoder() { super(); }
        
        public function writeBit(data:Boolean):void
        {
            this.writeBits(data ? 1 : 0, 1);
        }
    
        public function writeBits(data:int, size:int):void
        {
            while (size > 0)
            {
                if (size > _bitPos)
                {
                    //if more bits left to write than shift out what will fit
                    _currentBlock |= data << (32 - size) >>> (32 - _bitPos);
    
                    // shift all the way left, then right to right
                    // justify the data to be or'ed in
                    this.write(_currentBlock);
                    size -= _bitPos;
                    _currentBlock = 0;
                    _bitPos = 8;
                }
                else // if (size <= bytePos)
                {
                    _currentBlock |= data << (32 - size) >>> (32 - _bitPos);
                    _bitPos -= size;
                    size = 0;
    
                    if (_bitPos == 0)
                    {
                        //if current byte is filled
                        write(_currentBlock);
                        _currentBlock = 0;
                        _bitPos = 8;
                    }
                }
            }
        }
        
        public function getByteArray():ByteArray
        {
            var bar:ByteArray = new ByteArray();
            
            for (var i:int = 0; i < _blocks.length; i++)
            {
                bar.writeByte(_blocks[i]);
            }
            
            return bar;
        }
        
        private function write(block:int):void
        {
            if(block > 0xFF) throw new Error("byte write error");
            _blocks.push(block);
        }
        
        public static function minBits(number:int, bits:int):int
        {
            var val:int = 1;
            for (var x:int = 1; val <= number && !(bits > 32); x <<= 1) 
            {
                val = val | x;
                bits++;
            }
            
            if (bits > 32)
            {
                trace("minBits " + bits + " must not exceed 32");
            }
            return bits;
        }
    }
}