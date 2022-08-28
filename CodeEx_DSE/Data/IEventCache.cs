using CodeEx_DSE.Data.Models;

namespace 
    CodeEx_DSE.Data
{
    public interface IEventCache
    {
        Event Get(int eventId);
        void Remove(int eventId);
        void Set(Event question);
    }
}
