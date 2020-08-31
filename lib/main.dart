import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _Country {
  String iso2;
  String iso3;
  String name;
  String capital;
  String areaCode;
  String currency;

}

class _MyAppState extends State<MyApp> {
  var _counties = Map<String,_Country>();


  Future<Map<String,_Country>> _getData() async{
    var countries = Map<String,_Country>();
    await lookupCountry(countries);
    await lookupIOS3(countries);
    await lookupCapital(countries);
    await lookupAreaCode(countries);
    await lookupCurreny(countries);
    return countries;
  }
  Future<void> lookupCurreny(Map<String,_Country> countries) async{
    var url='http://country.io/currency.json';
    var response = await http.get(url);
    if (response.statusCode == 200){
      Map countryMap = jsonDecode(response.body);
      countryMap.forEach((key, value) {
        if (!countries.containsKey(key)){
          var country = _Country();
          country.iso2 = key;
          country.currency = value;
          countries.putIfAbsent(key, () => country);
        } else {
          var country = countries[key];
          country.currency = value;
        }
      });
    }
  }
  Future<void> lookupAreaCode(Map<String,_Country> countries) async{
    var url='http://country.io/phone.json';
    var response = await http.get(url);
    if (response.statusCode == 200){
      Map countryMap = jsonDecode(response.body);
      countryMap.forEach((key, value) {
        if (!countries.containsKey(key)){
          var country = _Country();
          country.iso2 = key;
          country.areaCode = value;
          countries.putIfAbsent(key, () => country);
        } else {
          var country = countries[key];
          country.areaCode = value;
        }
      });
    }
  }
  Future<void> lookupCapital(Map<String,_Country> countries) async{
    var url='http://country.io/capital.json';
    var response = await http.get(url);
    if (response.statusCode == 200){
      Map countryMap = jsonDecode(response.body);
      countryMap.forEach((key, value) {
        if (!countries.containsKey(key)){
          var country = _Country();
          country.iso2 = key;
          country.capital = value;
          countries.putIfAbsent(key, () => country);
        } else {
          var country = countries[key];
          country.capital = value;
        }
      });
    }
  }
  Future<void> lookupCountry(Map<String,_Country> countries) async{
    var url='http://country.io/names.json';
    var response = await http.get(url);
    if (response.statusCode == 200){
      Map countryMap = jsonDecode(response.body);
      countryMap.forEach((key, value) {
        if (!countries.containsKey(key)){
          var country = _Country();
          country.iso2 = key;
          country.name = value;
          countries.putIfAbsent(key, () => country);
        } else {
          var country = countries[key];
          country.name = value;
        }
      });
    }
  }
  Future<void> lookupIOS3(Map<String,_Country> countries) async{
    var url='http://country.io/iso3.json';
    var response = await http.get(url);
    if (response.statusCode == 200){
      Map countryMap = jsonDecode(response.body);
      countryMap.forEach((key, value) {
        if (!countries.containsKey(key)){
          var country = _Country();
          country.iso2 = key;
          country.iso3 = value;
          countries.putIfAbsent(key, () => country);
        } else {
          var country = countries[key];
          country.iso3 = value;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getData().then((value) => setState(()=>{this._counties = value}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView.builder(
              itemCount: _counties.length,
              itemBuilder: (context,index){
                var iso2 = _counties.keys.elementAt(index);
                return Card(
                    child : Column(
                      children: [
                        Text('${_counties[iso2].name}',style: TextStyle(fontSize: 15,color: Colors.blue)),
                        Wrap(
                          children: [
                            Text('ISO2 $iso2'),
                            SizedBox(width: 10,),
                            Text('ISO3 ${_counties[iso2].iso3}'),
                          ],
                        ),
                        Wrap(
                          children: [
                            Text('Capital ${_counties[iso2].capital}'),
                            SizedBox(width: 5,),
                            Text('Area Code ${_counties[iso2].areaCode}'),
                            SizedBox(width: 5,),
                            Text('Currency ${_counties[iso2].currency}'),
                          ],
                        )
                      ],
                    )
                );
              }
          ),
        )
    );
  }



}




