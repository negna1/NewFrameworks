# NewFrameworks

This is Exercise frameworks. 

first is realm : Realm is like core data, but it is much easier to use.

***Main Difference***

You’ll find that the class looks very much like a common Swift class.
This is one of the greatest things about Realm! You don’t have to go out of your way to adapt your code to work with the persistence layer. 
You always work with native classes like ToDoItem, while Realm does the heavy-lifting behind the scenes automatically. 
To recap:  the entity class you can persist on disk because it inherits from Realm’s base Object class.
The class is pretty much ready to go, so you can start adding the code to read and write to-do items from and to disk. 

The fact is that in order to use CoreData, you need a deep understanding of the API. In the case of Realm, everything is rather simpler.
CoreData manages objects explicitly in a ManagedObjectContext which you must save when making any changes.
On the other hand, Realm saves all changes in the recording blocks themselves, and it does so immediately. 
Therefore, in case of app failure (or exiting the simulator), you can check the mobile database right away and see how it looks.
