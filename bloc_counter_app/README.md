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

## Flutter BLoC concepts
- BlocProvider
- BlocBuilder
- BlocListner
- MultiBlocProvider
- MultiBlocListner

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