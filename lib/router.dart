//loggedOut
//loggedIn
import 'package:flutter/material.dart';
import 'package:reddit_clone/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';      



final loggedOutRoute = RouteMap(routes: {
  '/':(_) => const MaterialPage(child: LoginScreen())
});
final loggedInRouteProvider = RouteMap(routes: {
  '/loggedIn':(_) => const MaterialPage(child: Text('Logged In'))
}); 