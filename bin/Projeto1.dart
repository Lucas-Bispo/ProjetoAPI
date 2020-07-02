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
  String url = 'https://api.hgnbrasil.com/finance';

}