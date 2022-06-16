# bloc_counter_app

## Why BLoC

BLoC stands for Business Logic Component

Bloc is a design pattern created by Google to help seperate business logic from the presentation layer and enable developers to reuse code more easily

organising an app into maintainable chunks called the component/bloc or bloc component.

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
In Cubit the UI submits a function to call the cubit and return states.  
In Bloc the UI emits events which will return state to the UI.  
Both cubit and bloc can communicate with the outside data layer
A Cubit is a minimal version of a Bloc or a Bloc is an enhanced version of cubit.  
Bloc actually extends Cubit.

`Cubit` is a special kind of stream component which is based on some functions which are called from the UI, functions that rebuild the UI by emmiting different states on a stream. Note the functions the UI emits to a cubit are not Streams unlike a bloc where it not only emits a stream of states but also recieves a stream of events.

`BLoC` emits a stream of states and also recieves a stream of events.  
You can think of BLoC as the brain of an advanced and complex component from our app.  
The user can interact with the app and cause an event stream to be emitted to the BloC then inside the BLoc there will be a required `mapEventToState` function which will take the event and convert into a state so that the UI can rebuild

`When to use a Bloc or Cubit`  
Technically you will want a Cubit or Bloc for every feature of your app.

`Bloc vs Cubit`  
The main difference between a Bloc and a Cubit is how it receives input from the UI.

You could pretty much use Bloc and forget about cubit in your app, however a Bloc might be a bit overkill for say a simple counter app/feature

The Bloc can be thought of the main brain of the app/feature where a cubit can be used to optimize

Recomendation is to start with a cubit and expand it into a bloc if it is needed

## Flutter 101

Everything in flutter is a widget  
Every flutter BLoC concept is of course at the end of the day a widget.

So what exactly is a widget?  
Widgets in flutter are classes.  
Classes which have their own attributes and methods these classes can be instantiated as objects by defining there required methods and parameters into their constructor.

using the child we can have a tree of widgets to keep things organised

## Flutter BLoC concepts

- BlocProvider
  - creates and provides the only instance of a bloc to the subtree
- BlocBuilder
  - Rebulds the UI for every new state coming from the bloc
- BlocListner
- BlocConsumer
- MultiBlocListener, MultiBlocProvider, MultiRepositoryProvider

## `BlocProvider`

is used for both cubits and blocks, i.e they dont have seperate providers
A flutter widget which creates and provides a Bloc to all of its children.  
This is also known as a dependency injection widget so that a single instance of a bloc can be provided to multiple widgets within a subtree and all the widgets within now depend on it.  
BlocProvider will Provide a single instance of a BLOC to the subtree below it

Notes: you dont create a new BlocProvider for every place you want to use it, this is extremely bad!  
Instead it should be treated as dependenyc injection and be used at the highest place where all the children that need it can access it!

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

When flutter changes screens via navigation it wil l loose the context and therefore will not have the same instance of the Bloc it had before to pass the instance we need to use `BlocProvider.value()`

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

How to access the block?

```dart
BlocProvider.of<COunterCubit>(context).decrement();
// OR
context.bloc<CounterCubit>().decrement();
```

So now how do we recieve this state? A. BlocBuilder

## `BlocBuilder`

A widget that helps Re-Building the UI based on bloc state changes.  
This is the magic component which rebuiulds the UI every single time new state is emitted by either BLoC or Cubit.

Rebuilding a large chunk of the UI may require a lor of time to compute.

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

The builder function must be a pure function that returns a widget in response to a state.  
e.g it must be build using values from `context` and `state` only

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

## BlocListener

Much different to bloc builder which can be rebuilt many times, for example navigtang to another screen cant be done inside bloc builder as a response to a state change! because this action can be done multiple times. ie dont navigate to a screen based on state inside the builder. Same concept for arriving state when displaing a dialog or snackbar, the builder functin may be called muliple times.

BlocListner is a flutter widget which listens to any states changed as BlocBuilder does but instead of rebuilding the widget as blocbuilder did with the builder function it takes a void function called listener, which is called only once per state(not including initial state). There is also a listenWhen function for BlocListener

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/counter_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocListener<CounterCubit, CounterState>(
        listener: (context, state) {
          if (state.wasIncremented) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Incremented'),
                duration: Duration(milliseconds: 300),
              ),
            );
          } else if (state.wasIncremented == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Decremented'),
                duration: Duration(milliseconds: 300),
              ),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              BlocBuilder<CounterCubit, CounterState>(
                builder: (context, state) {
                  if (state.counterValue < 0) {
                    return Text(
                      'Brr NEGATIVE ${state.counterValue.toString()}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  } else if (state.counterValue == 12) {
                    return Text(
                      'A good number ${state.counterValue.toString()}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  } else if (state.counterValue % 2 == 0) {
                    return Text(
                      'YAAAY ${state.counterValue.toString()}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  } else {
                    return Text(
                      state.counterValue.toString(),
                      style: Theme.of(context).textTheme.headline4,
                    );
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      BlocProvider.of<CounterCubit>(context).decrement();
                    },
                    tooltip: 'Decrement',
                    child: const Icon(Icons.remove),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      BlocProvider.of<CounterCubit>(context).increment();
                    },
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

```

Yes there is an easier way to write the above code, i.e we do not need to use both BlocBuilder and BlocListener, we can isntead use BlocConsumer.

## `BlocConsumer`

A widget which combines both BlocListener and BlockBuilder into a single widget.

## `Bloc`

## `RespositoryProvider`

Is the same exact widget as BlocProvider, the only difference being that it provides a single repository
class instance instead of a single block instance.
i.e one provides a unuque instance of a BLOC (BlocProvider), while the other one provides a unique instance of a repository (RepositoryProvider).

A repository is a class which has the main functions which make flutter commmunicate with the outer data layer, the internet, the databases and so on.

In more feature rich applications you can imagine that there would be alot of cubits with their own functionality. So what are we going to do when we have 10 blocks to provide and listen to. We would use MultiBlockProvider, MultiBlocListener and MultiRepositoryProvider

```dart
MultiBlocProvider(
  providers:[
    BlocProvider<BlocA>(
      create: (BuildContext context) => BlocA(),
    ),
    BlocProvider<BlocB>(
      create: (BuildContext context) => BlocB(),
    ),
    BlocProvider<BlocC>(
      create: (BuildContext context) => BlocC(),
    ),
  ],
  child: ChildA(),
)
```

```dart
MultiBlocListener(
  listeners:[
    BlocListener<BlocA, BlocAState>(
      listener: (context, state) {},
    ),
    BlocListener<BlocB, BlocBState>(
      listener: (context, state) {},
    ),
    BlocListener<BlocC, BlocCState>(
      listener: (context, state) {},
    ),
  ],
  child: ChildA(),
)
```

```dart
MultiRepositoryProvider(
  providers:[
    RepositoryProvider<RepositoryA>(
      create: (context) => RespositoryA(),
    ),
    RepositoryProvider<RepositoryB>(
      create: (context) => RepositoryB(),
    ),
    RepositoryProvider<RepositoryC>(
      create: (context) => RepositoryC(),
    ),
  ],
  child: ChildA(),
)
```

## Bloc Architecture

What is an architecture?

What is it all about?

Why do we need an Architecture?

It is the skeletion/blueprint/structure of how your application should be built

Bloc is a:

- Design pattern
- State Management Library
- Architectural Pattern

for every action on the ui there should be an event dispatched to the bloc or cubit which will process it and eventually emit a state that will rebuild the ui.

Almost every app nowadays retrieves its data from the internet. So to link our bloc basde flutter app with the outer data layer we need to add the data layer.

The UI is seen as the presentation layer.

The Bloc/cubit as the business logic layer.

The apps data as the Data Layer

- Presentation Layer
- Business Logic Layer
- Data Layer

We will start with the data layer and work our way up to the presentation layer(UI)

- The Presentation Layer
- The Business Logic Layer
- The Data Layer
  - The Repositories
  - The Data Providers
  - The Models

## Data layer

The data layer has the responsibility of retrieveing and manipulating data from one or more sources. sources being either network requests, databases or other async resources. To do this the Data layer is split up into three important layers.

- The Models
- The DataProviders
- The Repositories

The best way to get started is by coding your Models

`The Models`: is a blueprint to the data your application will work with. to do this in flutter we crate a class with all its attributes e.g a Weather app.

```dart
class Weather {
  double temperature;
  List<double> forecast;
  List<Icon> icons;
  double windSpeed;
  ...etc,
}
```

These attributes should be linked from the data source but not completely. We should take the data we are interested in and that is all. A Model is simply a class which contains the data the application itself is dependent on. Models shpuld be independent of the source and should not be completely linked, they should be generic to multiple datasources

e.g a weather app that gets the weather from muliple sources and has the property "temperature" on one and "temp" on the other. they should feed into the same model

`The DataProviders`  
The DataProviders ressponsibility is to provide raw data to its successor, the repository sublayer.

Is actually an API for your own application, this means it will be a class containing different methods which will serve as a direct way to communicate with the datasources and is where all the magic happens, this is where flutter asks for the required data from the internet, all our get, put, delete methods etc go inside here.

Note that these <RawWeather> types wont be of the type we created earlier but rather tye type of data you recieved from the datasource for exampe a json string, the component which will have our Model class insantiated as objects is the repository.

The repository is mainy a wrapper around one or more data providers, it is safe to say it is the part of the data layer bloc communicates with.

```dart
class WeatherAPI {
  Future<RawWeather> getRawWeather(String city) async {
    RawWeather rawWeather = http.get('www.accuweather.com/${city}');
    return rawEather;
  }

  Future<RawWeather> getWeatherForCurrentLocation(Loctaion loc) async {
    RawWeather rawWeather = http.get('www.accuweather.com/${loc.city}');
    return rawEather;
  }
}
```

`A Repositry`  
A repository is a class which contain dependencies of their respective dataproviders. so the weather repos will have a dependency of the WeatherApi

```dart
class WeatherRepository {
  final WeatherAPI weatherAPI;
  // final OtherWeatherAPI otherWeatherAPI

  Future<Weather> getWeatherForLocation(String location) async {
    final RawWeather rawWeather await weatherAPI.getRawWeather(location);
    // final RawWeather rawWeather2 = await otherWeatherAPI.getRawWeather(location);

    final Weather weather = Weather.fromJSON(rawWeather);

    // a prefect place to fine tune the data before giving it as a response to the bloc.
    // here we can sort it and do any changes before it is sent to the business logic layer

    // weather.city = 'NewCity'

    return weather
  }
}
```

- The Presentation Layer
- The Business Logic Layer
- The Data Layer
  - The Repositories
  - The Data Providers
  - The Models

## The Business Logic Layer

Is where most of blocs and cubits will be created inside your flutter app, its main responsibility is to resond to the user input from the presentation layer with new emitted states. and is the mediator between the Presentation and data layers

Presentation Layer -- Business Logic Layer --- Data Layer

The business logic layer is the last layer which can intercept and catch any errors from within the data layer and prevent the application from crashing.

Since this layer is closely related to the data layer, especially the repository sublayer it can depend on one or more repositories to retrieve the data needed to build up the application state.

One important thing to note is the Blocs and cubits can comminicate with one another. e.g if we had A WeatherBloc and an InternetBloc, the internet bloc detects if there is a stabvle internet connection or not. inside the WeatherBloc you can depend on your InterntBloc and subscribe to its stream of emitted states, the react on every internet state emiited by the internet bloc.

```dart
class WeatherBloc extends Bloc {
  final InternetBloc internetBloc;
  StreamSubscription internetSubscription;

  WeatherBloc(this.internetBloc) {
    internetBlocSubsciption = internetBloc.listen((state){
      // dispact a NoInternetEventHere
    });
  }

  // must manually close as to not have memory leaks
  @override
  Future<void> close() {
    internetBlocSubscription.cancel();
    return super.close();
  }
}
```

NOTE: the subsciption to the block must be closed manualyy when subscrbing to another Bloc, this is done by ovverriding the close method! We do not want any stream leaks inside our app!

## The Presentation Layer

Is everything related to the UI, the widgets, user inputs, lifecycle events, animations etc. in the case of blocs its job is to figure out how to render itself based on one or more bloc states.

Mos applications will start with an app start event, which triggers the application to get some data from the data layer. for example when the forst screen of the app is loaded inside its constructor will be a WeatherBloc which will add the event

```dart
class HomeScreen {
  final WeatherBloc bloc;

  HomeScreen() {
    bloc.add(AppStarted());
  }
}
```

- lib
  - business_logic
    - blocs
    - cubits
  - data
    - subscriptions
    - models
    - repositories
  - presentation
    - animations
    - pages
    - screens
    - widgets

## Bloc Testing

- `flutter pub add bloc_test`
- `flutter pub add test --dev`

Every feature of your application needs to be tested, so the tests inside the test folder should be symetrical to the feature within the app

Now when testing apps output one instance wont be the same as another to solve this, wqe can make our classes extend equatable

`flutter pub add equatable`

you can run the test by running `pub run test`

## Bloc Access

- Local Access
- Route access
- Global access

## Bloc to Bloc Communication

- How to communicate
- StreamSubscription
- BlocListner

## Bloc 6.1.0 important changes

- context.watch()
- context.select()
- context.read()

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

## `Resources`

- [blocZeroToHero video](https://youtu.be/THCkkQ-V1-8)
- [blocZeroToHero repos](https://github.com/TheWCKD/blocFromZeroToHero)
- [Bloc 6.0 medium article](https://devmuaz.medium.com/cubit-has-been-merged-with-bloc-in-flutter-bloc-v6-0-0-42b80eb8a620)
