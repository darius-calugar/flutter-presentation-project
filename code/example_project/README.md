###### **Author:** Darius-Daniel Calugar
## Optional Report Example Project
This is an example **Flutter e-commerce mobile application**.

##### Functionalities
A user may **register** a new account or **login** with an already existing one. 
The application allows the user to **browse** a collection of products through **searching**, **sorting** and **filtering**. 
In addition, each product may be added to a user's the **favorites** list or to the user's **cart**.
The user may submit an order of the products from inside the **cart** through the **checkout** screen.

##### Important!
The application does not make use of a backend solution. Instead, all data is stored inside a mock *sqlite* database embedded in the final application and is reset on each rebuild.
Thus, the implementations of all methods in the `services` package should also be considered as mock, since the contents of that package varies heavily based on the backend solution of choice.
The service method signatures, however, are to be considered as part of the final product.

***

## Building and running the project
This guide explains the steps for building and running the application in **Android Studio**.

##### Environment Setup
- Install Android Studio
- Install the Flutter and Dart plugins
- Setup both Flutter and Dart SDKs from `Settings > Languages & Frameworks`
- Open the Android Virtual Device Manager and create a new android virtual device (API level 30 recommended).
- Launch the newly created virtual device.
- Select the virtual device from the list inside the Android Studio toolbar.

##### Running the application
- Run the commands `flutter pub get` and `flutter pub upgrade` in the project root. (Android Studio provides buttons for these operations when opening `pubspec.yaml`)
- Run the command `flutter run` to build and run the application.