package
{
    import flash.display.MovieClip;

    public class DomainCheckEntry extends MovieClip
    {

        public function DomainCheckEntry()
        {
            var _local_1:DomainValidator = new DomainValidator();

            if (!_local_1._SafeStr_247(this))
            {
                return;
            };
        }

    }
}
