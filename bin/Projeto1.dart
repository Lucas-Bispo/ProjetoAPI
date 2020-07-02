import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
void main() {
menu();
}

void menu(){

  print('################# Início #################');
  print('\n Selecione uma das opções abaixo:');
  print('1 - Ver a cotação de hoje');

  String option = stdin.readLineSync();

  switch(int.parse(option)){
    case 1: today(); break;
    default : print('\n\nOps, opção inválida. Selecione uma opção válida!\n\n'); menu(); break;
  }

}

today() async{
  var data = await getData();
  print('##################################### Hg Brasil - Coleção #####################################');
  print('${data['date']}-> ${data[data]}');

}
//espera a resposta de algo
//no caso desse projeto espera a resposta do site que usaremso no projeto
Future getData() async{
  String url = 'https://api.hgbrasil.com/finance?key=';
  http.Response response = await http.get(url);

  if(response.statusCode == 200){
    var data = json.decode(response.body)['results']['currencies'];
    var usd = data['USD'];
    var eur = data['EUR'];
    var gbp = data['GBP'];
    var ars = data['ARS'];
    var btc = data['BTC'];

    Map formateMap = Map();
    formateMap['date'] = '25/01/2019'; //now();
    formateMap['date'] = '${usd['name']}: ${usd['buy']} | ${eur['name']}: ${eur['buy']} | ${gbp['name']}: ${gbp['buy']} | ${ars['name']}: ${ars['buy']} | ${btc['name']}: ${btc['buy']}';
    
    return formateMap;
  }
  else
   throw('Falhou!');
}
String now(){

  var now = DateTime.now();
  return '${now.day.toString().padLeft(2 , '0')}/ ${now.month.toString().padLeft(2 , '0')}/ ${now.year.toString().padLeft(2 , '0')}';
}