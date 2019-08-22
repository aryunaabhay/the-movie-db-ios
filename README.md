# the-movie-db-ios
Test app using the movieDB api


### App Architecture

This app uses for its view components a modification of the MVVM design pattern that borrows the routers from the viper architecture and in terms of file structure the most significant trait is that it makes a strong distinction of code that is  directly a view component(screen or subviews) of the app or common logic exposed for use across the app or even logic that could be moved to a external library this is achieved by having the app_modules and the shared directories respectively.  

**App layers and the overall class correspondence**:

**Presentation**: views, viewcontrollers and logic around configuring the appearance of the app.  
**Business/Domain**: this layer is mainly formed by viewmodels, entities and other related logic with the use case in this domain.  
**Data Access**: Api services and Networking with alamofire.  
**Database/Persistance**: here Realm is the mechanism of persistance and the database itself.

### Overview of classes responsibilities:

On the app modules directory as I mentioned before each component follows the MVVM+R pattern in this case `Models` or `Entities` are in the shared directory and the `Views` as UIViews or ViewControllers only deal with showing the data from the viewmodel any event or data needed is communicated to the next component the `ViewModel` that is in charged of the business logic of that component requesting the needed data and transforming it the ways the use case needs so the view can show it correctly for naming conventions those clases always end on `ViewModel` to identify them easier, this also applies to the `Router` who is in charged of handling the needed preparations to load the component.

now for the shared directory we have different sub directories:

**appearance**: contains classes related to the appearance of the app like fonts, colors, themes, attributed string styles etc..  
**protocols**: as the name says contains the protocols that can be used across the app  
**services**: contains classes that hold some specific uses that can be reused across the app for example api services, in this case there are 2 the api service related to movies and the one related to tvshows there is also a class called ApiOperations that is an abstraction for any other kind of api service that can communicate to the server and map to the entities.  
**utilities**: this diretory contains the utility methods or computed variables that we would want to expose in general via class extensions.  
**entities**: contains the models/entities of the business domain that are used as the data across the app, in this case that i'm using realm those clases extend from Realm.Object if using coredata those clases would be NSManagedObjects.  
**networking**: here are the classes related to the barebones of the communications with the servers for now there is only one class call NetworkingClient that is in charge of wrapping the alamofire library and also add some specific detail of how we want to handle the communication with the server.  
and the AppConfiguration file that holds the App struct where the global variables of the app are gathered. (this could be splitted on different classes depending on the size of the app and the uses of those variables since this is small ap I choose to have them all in this struct)

### Single responsibility principle
The single responsibility principle is the S on SOLID design principles for OOP and the idea behind it, is that each class or component should only have a reason to change or that it should be in charge of one kind of responsibility for example the models or entities should only hold the definition of the object behaviour. the SRP in consequence helps the code to be more organized, easier to change and clear.

In my opinion good code or clean code first of all must be understandable, software always is evolving and can be changed by others or by you in the future so it should be above all understandable that means it should be readable has good name conventions and good naming should be organized should have a clear file structure, class structure and not bloated methods, has documentation. Then it should be easy to change or mantainable at some level I say at some level 'cause coupling exist at different levels and depending on the architecture decisions or time disposable to work on more verbose architectures. in the case of MVVM there is always a coupling of the view with its viewmodel but as far as the strong coupling makes sense there is no need to uncouple them or you can always move logic that can be reused for other MVVM components to a different class keeping that unit clean but still working in tandem, or if there is more time available create the needed protocols or interfaces that could potentially express those objects completely independent of the implementation details and depend only in the protocols. Also clean and good code should be reusable to avoid duplication of code and should be testable by leveraging the power of dependency injection or inversion to safeguard the code for future changes.  
