# bloc_counter_app

## Why BLoC
BLoC stands for Business Logic Component  

Bloc is a design pattern created by Google to help seperate business logic from the presentation layer and enable developers to reuse code more easily

organising an app into maintainable chunks called the  component/bloc or bloc component.  

What the user sees aka :
- The UI  
- The presentation layer
- The front-end

The Logic behind aka:
- The backend

It is important that for every interaction that happens in your app, there is some sort of UI feedback that lets the user know what is happening.
For every interaction the app should be in a different state  

Advantages of Boc:
- Understand easily whats happening inside your own app
- More structured code, easier to maintain and test
- Know and understand every state of your app
- Work on a single, stable, popular and effective BLoC codebase

## Core BloC concepts !important
The first thing to master is `streams` as they are the foundation of BLoC
- Streams
- Cubits
- BLoCs

Streams: `async*` is how to create an `Async Generator Function` and to send a piece of data from the stream you use the `yield` keyword. An async generator sends async data
```dart
Stream<int> boatStream() async* {
  for (int i = 1; i<=10; i++;) {
    print("SENT boat no. " + i.toString());
    await Future.delayed(Duration(seconds: 2));
    yield i;
  }
}

void main(List<String> args) async {
  Stream<int> stream = boatStream();

  stream.listen((receivedData) {
    print("RECEIVED boat no. " + receivedData.toString());
  });
}
```
We use the listen method to wait for incoming stream data

UI - Cubit - Data  
UI - Bloc - Data

The UI recieves states from the cubit or bloc.  
The cubit or bloc can make a request to recieve data and return some sort of response.
In Cubit  the UI submits a function to call the cubit and return states.  
In Bloc the UI emits events which will return state to the UI.  
Both cubit and bloc can communicate with the outside data layer
A Cubit is a minimal version of a Bloc or a Bloc is an enhanced version of cubit.  
Bloc actually extends Cubit.

`Cubit` is a special kind of stream component which is based on some functions which are called from the UI, functions that rebuild the UI by emmiting different states on a stream. Note the functions the UI emits to a cubit are not Streams unlike a bloc where it not only emits a stream of states but also recieves a stream of events.  

`BLoC` emits a stream of states and also recieves a stream of events.  
You can think of BLoC as the brain of an advanced and complex component from our app.  
The user can interact with the app and cause an event stream to be emitted to the BloC then inside the BLoc there qill be a required `mapEventToState` function which will take the event and convert into a state so that the UI can rebuild  

`When to use a Bloc or Cubit`  
Technically you will want a Cubit or Bloc for every feature of your app.  

`Bloc vs Cubit`  
The main difference between a Bloc and a Cubit is how it receives input from the UI. 

You could pretty much use Bloc and forget about cubit in your app, however a Bloc might be a bit overkill for say a simple counter app/feature  

The Bloc can be thought of the main brain of the app/feature where a cubit can be used to optimize  

Recomendation is to start with a cubit and expand it into a bloc if it is needed

## Flutter BLoC concepts
- BlocProvider
- BlocBuilder
- BlocListner
- BlocConsumer
- MultiBlocListener, MultiBlocProvider, MultiRepositoryProvider

`BlocProvider`  
A flutter widget which creates and provides a Bloc to all of its children.  
This is also known as a dependency injection widget so that a single instance of a bloc can be provided to multiple widgets within a subtree and all the widgets within now depend on it  
```dart
// The widget to provide the the bloc to the subtree
BlocProvider(
  create: (BuildContext context) => BlockA(),
  child: ChildA(),
);

// accessing
BlocProvider.of<BlocA>(context);
// Or
context.bloc<BlocA>();
```
By default, BlocProvider creates the bloc lazily  

It will create the block when it sees something like  
`BlocProvider.of<BlocA>(context)`  

This means that there won't be a ton of Bloc creation at the start  

This can of course be overriden to create the Bloc as soon as possible `lazy:false`
```dart
BlocProvider(
  lazy: false,
  create: (BuildContext context) => BlocA(),
  child: ChildA(),
);
```
When flutter changes screens via navigation it will loose the context and therefore will not have the same instance of the Bloc it had before to pass the instance we need to use `BlocProvider.value()` 
```
BlocProvider.value(
  value: BlocProvider.of<BlocA>(context),
  child: AnotherScreen(),
);
```
Since the only instance of BlocA was created with `BlocProvider`, it will get automatically closed by the BlocProvider!  

Providing it to the second page (using `BlocProvider.value`), won't close the only instance of the bloc when the second page gets destroyed!  

This is because the instance may still be needed in the page above, in the ancestor tree.  

However, the instance will be closed when needed, because of the way it was created in the first place (by using `BlocProvider`).

`BlocBuilder`  
A widget that helps Re-Building the UI based on bloc state changes  

You will want to wrap the smallest part of the widget that rebuilds.  
The builder function can be called multiple times due to how the flutter engine works  

The blob/cubit can be ommited & the instance will be searched via BlocProvider in the widget tree.
```dart
BlocBuilder<BlocA,BlocAState>(
  //cubit: BlocProvider.of<>BlocA(context)
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)
```
The builder function must be a pure function that returns a widget in response to a state

`pure function`  
is a function where the return value depends only on the functions arguments
```dart
// this is a pure function
int foo(int n) {
  return n * 2;
}

// this is not a pure function
int i = 42;
int bar(int n) {
  ++i;
  return n* i;
}
```

For more control over when the BlocProvider should rebuild you can provide the `buildWhen`
```dart
BlocBuilder<BlocA,BlocAState>(
  //cubit: BlocProvider.of<>BlocA(context)
  builder: (context, state) {
    // return widget here based on BlocA's state
  },
  buildWhen: (previousState, state) {
    // return true/false to determine wheter or not 
    // to rebuild the widget with state
  }
)
```



## Bloc Architecture
- Presentation Layer
- Business Logic Layer
- Data Layer

## Bloc Testing
- Why do you hate it
- Pros & Cons
- Tested counter app

## Bloc Access
- Local Access
- Route access
- Global access

## Bloc to Bloc Communication
- How to communicate
- StreamSubscription
- BlocListner

## Bloc 6.1.0 important changes
- `context.watch()`
- `context.select()`
- `context.read()`

## state not updating
- Dart `==` operator
- equatable package
- how to fix the issue

## Hydrated Bloc
- Maintaining state
- Data import/export (json)
- App internal storage

# VS Code extensions
- Better Comments `Aaron Bond`   
Improve your code commenting
- bloc `Felix Angelov`  
Support for the bloc library and provides tools
- Bracket Pair Colorizer 2 `CoenraadS`  
A customizable extension for colorizing matching brackets
- Dart `Dart Code`  
Dart language support and debugger for Visual Studio Code
- Dart Data Class Generator `BendixMa`  
Create dart data classes easily, fast and without writing boilerplate
- dart-import `Luan`  
Fix Dart/Flutter's imports
- Firebase Explorer `jsayol`  
Visual Studio Code extension to explore and manager your Firebase 


##Resources
- [blocZeroToHero video](https://youtu.be/THCkkQ-V1-8)
- [blocZeroToHero repos](https://github.com/TheWCKD/blocFromZeroToHero)
- [Bloc 6.0 medium article](https://devmuaz.medium.com/cubit-has-been-merged-with-bloc-in-flutter-bloc-v6-0-0-42b80eb8a620)